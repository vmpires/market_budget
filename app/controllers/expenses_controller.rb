class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: %i[ show edit update destroy ]

  # GET /expenses or /expenses.json
  def index
    # Loads expenses from current month by default
    start_date = Date.today.beginning_of_month
    end_date = Date.today.end_of_month
    @expenses = current_user.expenses.all.order(created_at: :asc).where(created_at: start_date..end_date)
  end

  def max
    @expenses = current_user.expenses.all.order(created_at: :asc)
  end

  def ytd
    current_year = Date.today.year
    start_date = Date.new(current_year,1,1)
    end_date = Date.new(current_year,12,31)
    @expenses = current_user.expenses.all.order(created_at: :asc).where(created_at: start_date..end_date)
  end

  def six_months
    start_date = Date.today - 6.months
    end_date = Date.today
    @expenses = current_user.expenses.all.order(created_at: :asc).where(created_at: start_date..end_date)
  end

  def twelve_months
    start_date = Date.today - 1.year
    end_date = Date.today
    @expenses = current_user.expenses.all.order(created_at: :asc).where(created_at: start_date..end_date)
  end

  # GET /expenses/1 or /expenses/1.json
  def show
  end

  # GET /expenses/new
  def new
    @expense = current_user.expenses.new
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses or /expenses.json
  def create
    params = { 
      title: expense_params[:title],
      value: expense_params[:value].gsub(',','.'),
      created_at: expense_params[:created_at]
    }
    @expense = current_user.expenses.new(params)
    respond_to do |format|
      if @expense.save
        format.html { redirect_to expense_url(@expense), notice: "Expense was successfully created!" }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to expense_url(@expense), notice: "Expense was successfully updated." }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    @expense.destroy

    respond_to do |format|
      format.html { redirect_to expenses_url, notice: "Expense was successfully destroyed!" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def expense_params
      params.require(:expense).permit(:title, :value, :created_at)
    end

    def convert(value)
      return if value.nil?
      ActionController::Base.helpers.number_to_currency(value.round(2), unit: "R$ ", delimiter: ".", separator: ",")
    end

    def convert_date(date)
      date.strftime("%d/%m/%Y")
    end

    def group_expenses(expenses)
      expenses = expenses.map { |e| {date: e.created_at.strftime("%m/%d/%Y"), value: e.value} }
      expenses.group_by { |d| d[:date] }.transform_values { |values| values.reduce(0) { |sum, v| sum + v[:value] } }
    end

    helper_method :convert
    helper_method :convert_date
    helper_method :group_expenses
end
