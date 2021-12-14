class V1::ItemsController < ApplicationController
  before_action :set_todo
  before_action :set_todo_item, only: %i[show update destroy]

  # GET /todos/:todo_id/items
  def index
    render json: ItemSerializer.new(@todo.items).serializable_hash.to_json,
           status: :ok
  end

  # GET /todos/:todo_id/items/:id
  def show
    render json: ItemSerializer.new(@item).serializable_hash.to_json,
           status: :ok
  end

  # POST /todos/:todo_id/items
  def create
    @todo.items.create!(items_params)
    render json: TodoSerializer.new(@todo).serializable_hash.to_json,
           status: :created
  end

  # PUT /todos/:todo_id/items/:id
  def update
    @item.update(items_params)
    head :no_content
  end

  # DELETE /todos/:todo_id/items/:id
  def destroy
    @item.destroy
    head :no_content
  end

  private

  def items_params
    params.permit(:name, :done)
  end

  def set_todo
    @todo = Todo.find(params[:todo_id])
  end

  def set_todo_item
    @item = @todo.items.find_by!(id: params[:id]) if @todo
  end
end
