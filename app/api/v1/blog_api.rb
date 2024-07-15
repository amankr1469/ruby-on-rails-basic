module V1
  class BlogAPI < Grape::API

    helpers AuthHelpers
    include JsonWebToken
    version 'v1', using: :path
    format :json
    before { authenticate }
    resources :blogs do
      desc 'Return a list of blogs'
      get do
        # Rails.cache.fetch('v1/blogs', expires_in: 5.minutes) do
        Blog.all
        # end
      end

      desc 'Return a single blog'
      params do
        requires :id, type: Integer, desc: 'ID of the blog'
      end
      get ':id' do
        Rails.cache.fetch("v1/blogs/#{params[:id]}", expires_in: 5.minutes) do
          Blog.find(params[:id])
        end
      end

      desc 'Create a new blog'
      params do
        requires :title, type: String, desc: 'Title of the blog'
        optional :description, type: String, desc: 'Description of the blog'
      end
      post do
        blog = Blog.create!(
          title: params[:title],
          description: params[:description]
        )
        Rails.cache.delete('v1/blogs')
        blog
      end

      desc 'Update a blog'
      params do
        requires :id, type: Integer, desc: 'Blog ID'
        optional :title, type: String, desc: 'Title of the blog'
        optional :description, type: String, desc: 'Description of the blog'
      end
      put ':id' do
        blog = Blog.find(params[:id])
        blog.update({
          title: params[:title],
          description: params[:description]
        }.compact)
        Rails.cache.delete("v1/blogs/#{params[:id]}") 
        Rails.cache.delete('v1/blogs')               
        blog
      end


      desc 'Delete a blog'
      params do
        requires :id, type: Integer, desc: 'Blog ID'
      end
      delete ':id' do
        blog = Blog.find(params[:id])
        blog.destroy
        Rails.cache.delete("v1/blogs/#{params[:id]}") 
        Rails.cache.delete('v1/blogs')               
      end
    end
  end
end