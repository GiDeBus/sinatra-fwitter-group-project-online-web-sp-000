class TweetsController < ApplicationController

    get '/tweets' do
        if logged_in?
            @tweets = Tweet.all
            erb :'/tweets/tweets'
        else
            redirect to '/login'
        end
    end

    get '/tweets/new' do
        if logged_in?
            erb :'/tweets/new'
        else
            redirect to '/login'
        end
    end

    post '/tweets' do
        if params[:content].blank?
            redirect to "/tweets/new"
        else
            @tweet = current_user.tweets.create(content: params[:content])
            redirect to "/tweets/#{@tweet.id}"
        end
    end

    get '/tweets/:id' do
       if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            erb :'/tweets/show_tweet'
       else
            redirect to '/login'
       end
    end

    get '/tweets/:id/edit' do
        if logged_in?
          @tweet = Tweet.find_by_id(params[:id])
            if @tweet && @tweet.user_id == current_user.id
              erb :'/tweets/edit_tweet'
            else
              redirect '/tweets'
            end
        else
          redirect to '/login'
        end
    end

    patch '/tweets/:id' do

        if params[:content].blank?
            redirect to "/tweets/#{params[:id]}/edit"
        else
            @tweet = Tweet.find_by_id(params[:id])
            if @tweet && @tweet.user == current_user
                if @tweet.update(content:params[:content])
                    redirect to "/tweets/#{@tweet.id}"
                else
                    redirect to "/tweets/#{@tweet.id}/edit"
                end
            end
        end    
    end

    delete '/tweets/:id/delete' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            if @tweet && @tweet.user_id == current_user.id
                @tweet.destroy
                redirect to "/tweets"
            end
        else
            redirect '/login'
        end
    end

end
