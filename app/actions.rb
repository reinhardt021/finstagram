helpers do 
    def current_user
        User.find_by(id: session[:user_id])
    end
end

# def humanized_time_ago(time_ago_in_minutes)
#     if time_ago_in_minutes >= 60
#         "#{time_ago_in_minutes / 60} hours ago"
#   else
#         "#{time_ago_in_minutes} minutes ago"
#   end
# end

get '/' do 
    @posts = Post.order(created_at: :desc)
    erb :index
#   "Hello world!" 
#   @post_shark = {
#       username: "sharky_j",
#       avatar_url: "http://naserca.com/images/sharky_j.jpg",
#       photo_url: "http://naserca.com/images/shark.jpg",
#       humanized_time_ago: humanized_time_ago(15),
#       like_count: 0,
#       comment_count: 1,
#       comments: [{
#           username: "sharky_j",
#           text: "Out for the long weekend... too embarrassed to show y'all the beach bod!"
#       }]
#   }
   
#     @post_whale = {
#       username: "kirk_whalum",
#       avatar_url: "http://naserca.com/images/kirk_whalum.jpg",
#       photo_url: "http://naserca.com/images/whale.jpg",
#       humanized_time_ago: humanized_time_ago(65),
#       like_count: 0,
#       comment_count: 1,
#       comments: [{
#           username: "kirk_whalum",
#           text: "#weekendvibes"
#       }]
#     }
   
#   @post_marlin = {
#       username: "marlin_peppa",
#       avatar_url: "http://naserca.com/images/marlin_peppa.jpg",
#       photo_url: "http://naserca.com/images/marlin.jpg",
#       humanized_time_ago: humanized_time_ago(190),
#       like_count: 0,
#       comment_count: 1,
#       comments: [{
#           username: "marlin_peppa",
#           text: "lunchtime! ;)"
#       }]
#   }
   
#   @posts = [@post_shark, @post_whale, @post_marlin]
end

get '/signup' do
    @user = User.new
    erb :signup
end

post '/signup' do
    # "Hello World"
    # "Form submitted!"
    # params.to_s
    email       = params[:email]
    avatar_url  = params[:avatar_url]
    username    = params[:username]
    password    = params[:password]
    
    
    # if email.present? && avatar_url.present? && username.present? && password.present?
        @user = User.new({
            email: email,
            avatar_url: avatar_url,
            username: username,
            password: password 
        })
        if @user.save
            # escape_html user.inspect
            # "User #{username} saved!"
            redirect(to('/login'))
        else
            # escape_html user.errors.full_messages
            erb(:signup)
        end
    # else
        # "Validation failed."
    # end
end

get '/login' do
    @user = User.new
    erb :login
end

post '/login' do
    # params.to_s
    username = params[:username]
    password = params[:password]
    
    user = User.find_by(username: username)
    
    if user && user.password == password
       session[:user_id] = user.id
       redirect(to('/')) 
    else
        @error_message = "Login failed"
        erb(:login)
    end
    
end

get '/logout' do
   session[:user_id] = nil
   redirect(to('/'))
end

get '/posts/new' do 
    @post = Post.new
    erb(:"posts/new")
end

post '/posts' do
    photo_url = params[:photo_url]
    
    @post = Post.new({ photo_url: photo_url, user_id: current_user.id })
    
    if @post.save
        redirect(to('/'))
    else
    #   @post.errors.full_messages.inspect 
        erb(:"posts/new")
    end
end

get '/posts/:id' do
    # params[:id]
    @post = Post.find(params[:id])
    # escape_html @post.inspect
    erb(:"posts/show")
end

post '/comments' do 
    # params.to_s
    text = params[:text]
    post_id = params[:post_id]
    
    comment = Comment.new({ 
        text: text,
        post_id: post_id,
        user_id: current_user.id
    })
    
    comment.save
    
    redirect(back)
end

post '/likes' do
    post_id = params[:post_id]
    
    like = Like.new({
        post_id: post_id,
        user_id: current_user.id
    })
    like.save
    
    redirect(back)
end

delete '/likes/:id' do
    like = Like.find(params[:id])    
    like.destroy
    redirect(back)
end

