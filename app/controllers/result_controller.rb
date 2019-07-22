class ResultController < ApplicationController
  require 'active_support/core_ext' #date
  def show

    ## 入力値の制御
    
    if params[:resultpr][:date_span_from].blank? or params[:resultpr][:date_span_to].blank?
      # 開始日,終了日が未設定の場合エラー
      
      flash[:danger] = '開始日、終了日は入力必須です。'
      redirect_to main_page_show_path      
    elsif params[:resultpr][:date_span_from] > params[:resultpr][:date_span_to]
      # 開始日>終了日の場合エラー
      
      flash[:danger] = '終了日には開始日以降の値を入力してください。'
      redirect_to main_page_show_path      
    
    else
      
      ##変数定義
      # 集計開始日
      @date_span_from = params[:resultpr][:date_span_from]
      # 集計終了日
      @date_span_to = params[:resultpr][:date_span_to]
      # 集計開始日のdatetime型
      @datetime_span_from = @date_span_from.to_datetime
      # 集計終了日のdatetime型。終了日のイベントを全て含めるため0:00から23:59に修正。
      @datetime_span_to = @date_span_to.to_datetime.end_of_day
      # 集計空白時間フラグ
      @empty_flg = params[:resultpr][:empty_flg]
      # (開始日-終了日)（日） *24（時間）* 60（分）* 60（秒）＝開始日と終了日の差（秒）
      @span = (@datetime_span_to - @datetime_span_from )*24*60*60
      @categoriesSum = Hash.new #カテゴリー別集計
      @eventDate = Hash.new  { |h,k| h[k] = {} } #期間別集計
      # 空白時間計算用変数
      @caluculate_empty = 100
      
      ##集計範囲のイベントを取得
      #イベント（範囲すべて）
      @events = Event.where("user_id = ?", current_user).where("start >= ?", @datetime_span_from)
                          .where('"end" <= ?', @datetime_span_to).order(start: "ASC")
                            
      ## イベント（無駄フラグ用）
      @events_useless = Event.where(["user_id = ? and useless_flag = ?", current_user, true])                          
      
      logger.debug(@events.inspect)
      logger.debug(@events_useless.inspect)
      
      ## ハッシュ関数初期化
      Category.all.each do |category|
        # カテゴリ別ー集計用
        @categoriesSum[category.id] = 0
        
        # 期間別集計用
        # 集計開始日～集計終了日までハッシュ関数の初期値設定
        @cal_date = @datetime_span_from
        for @cal_date in @datetime_span_from..@datetime_span_to do
          @eventDate[category.id][@cal_date.strftime("%Y/%m/%d")] = 0
          # 日付を＋１する
          @cal_date.since(1.days)
        end
      end
      
      ## カテゴリー別集計開始
      @events.each do |event|
          logger.debug(event.inspect)
          @calculate = (event.end - event.start)/@span
          
          #@categoriesSum[event.category_id] = 0  
          @categoriesSum[event.category_id] += @calculate * 100
          
          ##eventのcategory_idをkeyとして取得した値に、計算結果を＋してゆく。
          ##eventは、category.category_id順に取得しておきます。
          ##なので、category_id と　category_valは、同じレコードから取得値ということが成立します。
          ## {category_id : 1, category_val : "Game"}
          ## category_id = 1をもつレコードを複数取得した場合、
          ## category_id１に計算結果を追加していきます。
          
          ## 空白の時間を計算開始
          # 空白の時間を集計するためにeventのcategory_idをkeyとして取得した値に、計算結果をspanから引いていく。
          @caluculate_empty -= @calculate*100
          logger.debug(@caluculate_empty)
  
          @eventDate[event.category_id][event.start.to_date.strftime("%Y/%m/%d")] += @calculate * 100;
              logger.debug("!!!!! @eventDate の確認です！！！！！")
          # logger.debug(dates.inspect)
        end
        
        ## 無駄フラグがONのイベント集計開始
        @events_useless.each do |event|
          logger.debug(event.inspect)
          # 無駄フラグONの時間の合計値を計算
          @sum_useless = (event.end - event.start)/@span * 100 
        end
        
      #For Debug. You can debugging on the Terminal
      logger.debug(@categoriesSum.inspect)
      logger.debug("!!!!! @eventDate の確認です！！！！！")
      logger.debug(@eventDate.inspect)
  
    end
  end
end
