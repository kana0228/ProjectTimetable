class ResultController < ApplicationController
  require 'active_support/core_ext' #date
  def show
    #@events = Event.all
    
    #@categories = Category.all
    
    # Category.all.each do |category|
    #   @categories_id = category.id
    #   @categories_val = category.val
    # end
    
    # @one_categories = Category.where(id:"1")
    # @two_categories = Category.where(id:"2")
    
    ## 集計開始日
    @date_span_from = params[:resultpr][:date_span_from]
    ## 集計終了日
    @date_span_to = params[:resultpr][:date_span_to]
    ## 集計開始日のdatetime型
    @datetime_span_from = @date_span_from.to_datetime
    ## 集計終了日のdatetime型。終了日のイベントを全て含めるため0:00から23:59に修正。
    @datetime_span_to = @date_span_to.to_datetime.end_of_day
    ## 集計空白時間フラグ
    @empty_flg = params[:resultpr][:empty_flg]
    ## (開始日-終了日)（日） *24（時間）* 60（分）* 60（秒）＝開始日と終了日の差（秒）
    @span = (@datetime_span_to - @datetime_span_from )*24*60*60
    @categoriesSum = Hash.new
    @eventDate = Hash.new
    @sum = 0;
    
    ## 入力値の制御 narukiyo start
    ## 開始日>終了日の場合エラー narukiyo 
    if @date_span_from > @date_span_to
      flash[:error] = '終了日には開始日以降の値を入力してください。'
      redirect_to main_page_show_path      
    end
    ## 入力値の制御 narukiyo end
    
    @events = Event.where(["user_id = ? and start >= ? and end <= ?",
                          current_user, @datetime_span_from, @datetime_span_to ])
                          .order(start: "ASC")
                          
    # イベント（無駄フラグ用）
    @events_useless = Event.where(["user_id = ? and Useless_flag = ?", current_user,true])                          
    
    logger.debug(@events.inspect)
    logger.debug(@events_useless.inspect)
    
      # 集計用
    @events.each do |event|
        logger.debug(event.inspect)
        @calculate = (event.end - event.start)/@span #名前は適当に作りました。Local Variable
        
        @categoriesSum[event.category_id] = 0  
        @categoriesSum[event.category_id] += @calculate * 100 ##（%）ここの処理が理解できない。
        ##単位は何ですか？結果画面には％で表示されますが、パーセンテージであっていますか？→単位は%であっています！##0602naru
        
        ##eventのcategory_idをkeyとして取得した値に、計算結果を＋してゆく。
        ##eventは、category.category_id順に取得しておきます。
        ##なので、category_id と　category_valは、同じレコードから取得値ということが成立します。
        ## {category_id : 1, category_val : "Game"}
        ## category_id = 1をもつレコードを複数取得した場合、
        ## category_id１に計算結果を追加していきます。
        
        
        @eventDate[event.start.to_date.strftime("%Y/%m/%d")] = 0;
        @eventDate[event.start.to_date.strftime("%Y/%m/%d")] += @calculate * 100
        #start.to_date.strftime("%Y/%m/%d")
        #取得したDateTime型のデータをDate型に変換して、決まったFormatの文字列に変換します。
        # %Y 4桁年　表示
        ##画面遷移後ログ確認してみてください！
        

      end
      
      # 集計用（無駄フラグがONのイベントの時間を集計する）
      @events_useless.each do |event|
        logger.debug(event.inspect)
        # 無駄フラグONの時間の合計値を計算
        @sum_useless = (event.end - event.start)/@span * 100 
      end
    #For Debug. You can debugging on the Terminal
    # logger.debug(@events.inspect)
    logger.debug(@categoriesSum.inspect)
    logger.debug(@sum.inspect)
    logger.debug(@eventDate.inspect)
    
    
    # @one_events = Event.where(user: '1',category_id: '1')
    #               .where("start >= ?",@datetime_span_from)
    #               .where("start <= ?",@datetime_span_to)  
    # # #ユーザはTwitterからもらう #カテゴリーはカテゴリー分実施   
    # @two_events = Event.where(user: '1',category_id: '2')
    #               .where("start >= ?",@datetime_span_from)
    #               .where("start <= ?",@datetime_span_to)
    # # #カテゴリーはカテゴリー分実施   

  end
end
