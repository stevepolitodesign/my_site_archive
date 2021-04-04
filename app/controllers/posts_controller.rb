class PostsController < ApplicationController
    include ActionView::Helpers::AssetUrlHelper
    include Schemable

    before_action :set_post, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, except: [:show, :index]

    def index
        @posts = policy_scope Post.all.includes([:rich_text_content, :featured_image_attachment]).order(created_at: :desc)
    end

    def show
        authorize @post
        set_meta_tags   title: @post.title,
                        description: @post.meta_description,
                        site: nil
        set_schema_dot_org(schema: {
            :@type => "BlogPosting",
            :mainEntityOfPage => {
                :@type => "WebPage",
                :@id => post_url(@post)
            },
            :headline => @post.title,
            :image => [
                url_for(@post.featured_image) if @post.featured_image.attached?,
            ],
            :datePublished => @post.created_at,
            :dateModified => @post.updated_at,
            :author => {
                :@type => "Person",
                :name => "Steve Polito",

            },
            :publisher => {
                :@type => "Organization",
                :name => "My Site Archive",
                :logo => {
                    :@type => "ImageObject",
                    :url => asset_url("assets/amp_logo.png")
                }
            }
        })
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
        if @post.update_attributes(post_params)
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
            params.require(:post).permit(:title, :meta_description, :slug, :status, :content, :featured_image)
        end

        def set_post
            @post = Post.friendly.find(params[:id])
        end
end
