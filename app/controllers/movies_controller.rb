class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    # params[:sort_by]
    @movies.order!(params[:sort_by])
  
  end

  def updateComplete
  end
  
  def updateCompletely
    puts "In updateCompletely()"
    @input = params[:movie]
    puts @input
    if @movie = Movie.find_by_title(@input[:name])
      puts "Movie does exist"
      if !(@input[:title]=="" && @input[:rating]=="" && @input[:release_date]=="")
        @movie.update_attributes!(movie_params)
        flash[:notice] = "#{@movie.title} was successfully updated."
        redirect_to movies_path
      else
        flash[:notice] = "Movie not updated. Please fill in all the details."
        redirect_to updateComplete_movies_path
      end
    else
      flash[:notice] = "#{@input[:name]} does not exist"
      redirect_to updateComplete_movies_path
    end
  end

  def deleteTitle
  end

  def deleteTitleMovies
    @input = params[:movie]
    puts @input
    if @movie = Movie.find_by_title(@input[:title])
      puts "Movie does exist"
      @movie.destroy
      flash[:notice] = "#{@movie.title} was successfully deleted."
      redirect_to movies_path
    else
      flash[:notice] = "#{@input[:title]} does not exist"
      redirect_to deleteTitle_movies_path
    end
  end

  def deleteRating
  end
  
  def deleteRatingMovies
    @input = params[:movie]
    puts @input
    Movie.where(rating: @input[:rating]).each do |mov|
      mov.destroy
    end
    flash[:notice] = "Movies with rating #{@input[:rating]} were successfully deleted."
    redirect_to movies_path
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
