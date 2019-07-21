class MainPageController < ApplicationController
  
  def delete
    logger.debug("!!!!!! Delete Data !!!!")
    logger.debug(params[:id])
    @event = Event.find_by(id: params[:id])
    @event.destroy
      respond_to do |format|
        format.html { redirect_to '/main_page/show', notice: 'Event was successfully deleted.' }
        format.js { @status = "deleted" }
      end
  end
  
  def cancel
    #render action: :show #★レンダリングにするとmain_page_showの54行目でエラーになってしまう
    #createと同様に記載すれば同様に動くかと思ったけど再表示になってしまう。これなら普通に_eventModalでredirect_toしたら良いかも
    #エラーメッセージがモーダルに出力されたままcancelボタンを押すと、メインページのエラーが表示されてしまう。
      respond_to do |format|
        format.html { redirect_to '/main_page/show'}
        format.js { @status = "canceled" }
      end    
  end
  def edit
     @event = Event.find_by(id: params[:id])
     logger.debug("Edit Debug event !!!!!!!!!!1")
     logger.debug(@event.inspect)
  end
  
  def update
    @event = Event.find(params[:event][:id])
    time_s = params[:date] + " "+ params[:event][:start] #concat date and time_from
    time_e = params[:date] + " " + params[:event][:end] #concat date and time_to
    time_s.to_datetime #convert String to Datetime
    time_e.to_datetime #convert String to Datetime
    @event.update(start:time_s, end:time_e, title:params[:event][:title],
      category_id:params[:event][:category_id],useless_flag:params[:event][:useless_flag], 
      user_id: current_user.id)
      #return redirect_to main_page_show_path
      respond_to do |format|
        format.html { redirect_to main_page_show, notice: 'User was successfully created.' }
        format.js { @status = "created" }
      end      
  end

  def show
    #@category = Category.all
    @resultpr = Resultpr.new
    if(params[:event_sonzai_flg] == "1") then
      @event = Event.find(params[:id])
      @event.start = @event.start.to_s
      @event.end = @event.end.to_s
       render :json => @event
    else
      @event = Event.new 
    end
    logger.debug("Debug event_cont !!!!!!!!!!1")
    logger.debug(@event.inspect)
  end
    
  def create
    
    logger.debug(current_user)
    time_s = params[:date] + " "+ params[:event][:start] #concat date and time_from
    time_e = params[:date] + " " + params[:event][:end] #concat date and time_to
    time_s.to_datetime #convert String to Datetime
    time_e.to_datetime #convert String to Datetime
    
    ## 入力値制御
    if params[:date].blank?
      # 日時必須入力
      logger.debug("falsh処理！！！！！！！！！")
        respond_to do |format|
          format.js { flash[:danger] = "日時は必須入力です。" ,
            @status = "fail"
          }
        end       
    elsif params[:event][:start].blank?
      # 開始時刻必須入力
      logger.debug("falsh処理！！！！！！！！！")
        respond_to do |format|
          format.js { flash[:danger] = "開始時間は必須入力です。" ,
            @status = "fail"
          }
        end    
    elsif params[:event][:end].blank?
      # 終了時刻必須入力
      logger.debug("falsh処理！！！！！！！！！")
        respond_to do |format|
          format.js { flash[:danger] = "終了時間は必須入力です。" ,
            @status = "fail"
          }
        end   
    elsif params[:event][:title].blank?
      # 予定内容必須入力
      logger.debug("falsh処理！！！！！！！！！")
        respond_to do |format|
          format.js { flash[:danger] = "予定内容は必須入力です。" ,
            @status = "fail"
          }
        end   
    elsif params[:event][:category_id].blank?
      # カテゴリー必須入力
      logger.debug("falsh処理！！！！！！！！！")
        respond_to do |format|
          format.js { flash[:danger] = "カテゴリーは必須入力です。" ,
            @status = "fail"
          }
        end           
    elsif time_s > time_e
      logger.debug("falsh処理！！！！！！！！！")
        respond_to do |format|
          format.js { flash[:danger] = "終了時間には開始時間以降の値を入力してください。" ,
            @status = "fail"
          }
        end
      # redirect_to message_index_path   
      
    else
      ## 入力値にエラーがない場合
      
      ## 更新処理
      if params[:event][:id].blank? != true
        return self.update
      end      
      
      ## 登録処理
      logger.debug("現在のユーザー確認！！！！！！！！！")
      logger.debug(current_user.inspect)
      event = Event.new(start:time_s, end:time_e, title:params[:event][:title],
      category_id:params[:event][:category_id],useless_flag:params[:event][:useless_flag], 
      user_id: current_user.id )
      
      logger.debug(event.inspect)
      begin
        if event.save! #save the object data to DB　=> Create id and created_time, updated_time automatically.
        # redirect_to main_page_show_path
          respond_to do |format|
            format.html { redirect_to main_page_show, notice: 'User was successfully created.' }
            format.js { @status = "created" }
          end
        end
        rescue Exception => e
          respond_to do |format|
            format.html { redirect_to main_page_show, notice: "User wasn't successfully created." }
            format.js { flash[:danger] = "この時間帯には入力できません。" ,
            @status = "fail" }
          end
        end
      #event = Event.new #Create Event Object
      #logger.debug(event) 
      #event.time_from = time_f  #insert datetime
      #event.time_to = time_t  #insert datetime
      #logger.debug(event.inspect) #how to debug
      #event.content = params[:event][:content]
      #event.category_id = params[:event][:category_id]
      #event.useless_flag = params[:event][:useless_flag]
      #logger.debug(event.inspect) #how to debug-->
    end
  end

  #DBの値をfulcalendarに表示する処理
  def events
    @event = Event.where(user: current_user)
    logger.debug("!!!! Fullcalendar 処理をしています。 !!!!!")
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
