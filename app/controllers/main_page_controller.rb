class MainPageController < ApplicationController
  
  def edit
     @event = Event.find_by(id: params[:id])
     logger.debug("Edit Debug event !!!!!!!!!!1")
     logger.debug(@event.inspect)
  end
  
  def update
    time_s = params[:date] + " "+ params[:event][:start] #concat date and time_from
    time_e = params[:date] + " " + params[:event][:end] #concat date and time_to
    time_s.to_datetime #convert String to Datetime
    time_e.to_datetime #convert String to Datetime
    @event.update(start:time_s, end:time_e, title:params[:event][:title],
      category_id:params[:event][:category_id],useless_flag:params[:event][:useless_flag], 
      user_id: current_user.id)
      redirect_to main_page_show_path
  end

  def show
    #@category = Category.all
    @resultpr = Resultpr.new
    @event = Event.new 
    logger.debug(params[:event_sonzai_flg])
    if(params[:event_sonzai_flg] == "1") 
      @event = Event.find_by(id: params[:id])
       render :json => @event
    end
    logger.debug("Debug event_cont !!!!!!!!!!1")
    logger.debug(@event.inspect)
  end
    
    

#narukiyo add start      
    #カレンダーからのパラメータ
    #イベント存在フラグ

    #イベントが存在する場合（クリックしたのがイベント登録あり）
    #対象のイベントのデータを取得

#narukiyo add end
  
  
  
  def create
    logger.debug(current_user)
    time_s = params[:date] + " "+ params[:event][:start] #concat date and time_from
    time_e = params[:date] + " " + params[:event][:end] #concat date and time_to
    time_s.to_datetime #convert String to Datetime
    time_e.to_datetime #convert String to Datetime
    
    ## 入力値制御 narukiyo start
    ## 日付の理論制御 narukiyo 
    if time_s > time_e
      #flash[:error1] = '終了時間には開始時間以降の値を入力してください。'
      flash[:danger] = '終了時間には開始時間以降の値を入力してください。'
      redirect_to main_page_show_path   
      
      
    else
      ## 入力値にエラーがない場合
      ## 入力値の制御　narukiyo end
      logger.debug("現在のユーザー確認！！！！！！！！！")
      logger.debug(current_user.inspect)
      event = Event.new(start:time_s, end:time_e, title:params[:event][:title],
      category_id:params[:event][:category_id],useless_flag:params[:event][:useless_flag], 
      user_id: current_user.id )
      
      logger.debug(event.inspect)
      
      #event = Event.new #Create Event Object
      #logger.debug(event) 
      #event.time_from = time_f  #insert datetime
      #event.time_to = time_t  #insert datetime
      #logger.debug(event.inspect) #how to debug
      #event.content = params[:event][:content]
      #event.category_id = params[:event][:category_id]
      #event.useless_flag = params[:event][:useless_flag]
      #logger.debug(event.inspect) #how to debug-->
      event.save #save the object data to DB　=> Create id and created_time, updated_time automatically.
      redirect_to main_page_show_path
    end
  end

#narukiyo add start  実験で作っただけこれはきにしないで現状どこからも使用されてない
  def reshow
    #カレンダーからのパラメータ
    #イベント存在フラグ
    @event_sonzai_flg = params[:event_sonzai_flg]
    logger.debug("Debug !!!!!!!!!!1")
    logger.debug(@event_sonzai_flg.inspect)
    logger.debug(params[:id])
    #クリックしたイベントのID
    @event_id = params[:id] 
    
    #イベントが存在する場合（クリックしたのがイベント登録あり）
    #対象のイベントのデータを取得
    if(@event_sonzai_flg == "1") 
      @event_cont = Event.where(["id = ?", params[:id]])
      logger.debug("Debug event_cont !!!!!!!!!!1")
      logger.debug(@event_cont.inspect)
    end
    redirect_to main_page_show_path 
  end
#narukiyo add end  　実験で作っただけこれはきにしないで現状どこからも使用されてない

  ##修正必要。user_idでデータを探してそのデータだけ表示できるようにすれば。？★→ユーザIDベタ書き。取得してほしい。
  ### ダフン：application_controllerにていくつかのメソッドを実装しています。
  def events
    
    @event = Event.where(user: current_user)
    respond_to do |format|
      format.json{
        render json:
        @event.to_json(
          only: [:title,:start,:end, :id]
          )
      }
    end
  end
end
