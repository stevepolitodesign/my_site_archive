class PostsController < ApplicationController
    before_action :set_post, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, except: [:show, :index]

    def index
        @posts = Post.all.includes([:rich_text_content]).order(created_at: :desc)
    end

    def show
        authorize @post
    end

    def new
        @post = Post.new
        authorize @post
    end

    def create
        @post = Post.create(post_params)
        authorize @post
        if @post.save
            redirect_to @post, notice: "Post created."
        else
            render "new" 
        end
    end

    def edit
        authorize @post
    end

    def update
        authorize @post
        if @post.update(post_params)
            redirect_to @post, notice: "Post updated."
        else
            render "edit"
        end
    end

    def destroy
        authorize @post
        @post.destroy
        redirect_to posts_path, notice: "Post deleted."
    end
    
    private

        def post_params
            params.require(:post).permit(:title, :meta_description, :status, :content)
        end

        def set_post
            @post = Post.friendly.find(params[:id])
        end
end
