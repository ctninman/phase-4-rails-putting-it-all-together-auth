class RecipesController < ApplicationController

  before_action :authorize

  def index
    user = User.find_by(id: session[:user_id])
    if user
      recipes = Recipe.all
      render json: recipes, status: :created
    else
      render json: {error: "Not authorized"}, status: :unauthorized
    end
  end

  def create
    user = User.find_by(id: session[:user_id])
    if user
      recipe = user.recipes.create(recipe_params)
      if recipe.valid?
        recipe.save
        render json: recipe, status: :created
      else
        render json: {errors: recipe.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {errors: recipe.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def authorize
    return render json: {errors: ['error1', 'error2']}, status: :unauthorized unless session.include? :user_id
  end

  def recipe_params
    params.permit(:title, :instructions, :minutes_to_complete, :user_id)
  end

end
