class V1::TodosController < ApplicationController
  before_action :set_todo, only: %i[show update destroy]
  after_action { pagy_headers_merge(@pagy) if @pagy }

  # GET /todos
  def index
    @pagy, @todos = pagy(current_user.todos)
    render json: TodoSerializer.new(@todos).serializable_hash.to_json,
           status: :ok
  end

  # POST /todos
  def create
    @todo = current_user.todos.create!(todo_params)
    render json: TodoSerializer.new(@todo).serializable_hash.to_json,
           status: :created
  end

  # GET /todos/:id
  def show
    render json: TodoSerializer.new(@todo).serializable_hash.to_json,
           status: :ok
  end

  # PUT /todos/:id
  def update
    @todo.update(todo_params)
    head :no_content
  end

  # DELETE /todos/:id
  def destroy
    @todo.destroy
    head :no_content
  end

  private

  def todo_params
    # whitelist params
    params.permit(:title)
  end

  def set_todo
    @todo = Todo.find(params[:id])
  end
end
