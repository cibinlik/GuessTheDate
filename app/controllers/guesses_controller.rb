class GuessesController < ApplicationController
  before_action :set_guess, only: [:show, :edit, :update, :destroy]

  # GET /guesses
  # GET /guesses.json
  def index
    @guesses = Guess.all
  end

  # GET /guesses/1
  # GET /guesses/1.json
  def show
  end
  
  def year
    #@exclude = Answer.select("question_id").where("user_id = (?)", current_or_guest_user.id)
    #@question = Question.where("id not in (?)", @exclude).order("RANDOM()").limit(1).first
    #@information = Information.order("RANDOM()").limit(1).first
    @information = Information.order("RANDOM()").limit(1).first
    @guess = Guess.new
    flash[:information_id] = @information.id
  end
  
  def month
    @information = Information.order("RANDOM()").limit(1).first
    @guess = Guess.new
    flash[:information_id] = @information.id
  end
  
  def day
    @information = Information.order("RANDOM()").limit(1).first
    @guess = Guess.new
    flash[:information_id] = @information.id
  end
  
  def date
    @information = Information.order("RANDOM()").limit(1).first
    @guess = Guess.new
    flash[:information_id] = @information.id
  end
  

  def result
    information_id = flash[:information_id] #get the id from the create action
    @information = Information.find(information_id) #find which info is asked by getting from DB
    guess_id = flash[:guess_id] #get the id from the create action
    @guess = Guess.find(guess_id) #find that guess from DB
    
    case @guess.kind #which path to be used.
    when 1
      @path = month_path
    when 2
      @path = day_path
    when 3
      @path = year_path
    when 4
      @path = date_path
    end
    
  end

  # GET /guesses/new
  def new
    @guess = Guess.new
  end

  # GET /guesses/1/edit
  def edit
  end
  
  
  # POST /guesses
  # POST /guesses.json
  def create
    @guess = Guess.new(guess_params)

    information_id = flash[:information_id] #which information is asked on the guess page.
    @information = Information.find(information_id) #use the ID to check info from DB
    flash[:information_id] = information_id #pass the id for the result page
    flash[:guess_id] = @guess.id #pass the id for the result page
    

    case @guess.kind
    when 1 #month
      @guess.delta = @information.month - @guess.answer
      @guess.score = (1 - (@guess.delta / 12.to_f)) * 10000
    when 2 #day
      @guess.delta = @information.day - @guess.answer
      @guess.score = (1 - (@guess.delta / 31.to_f)) * 10000
    when 3 #year 
      @guess.delta = @information.year - @guess.answer
      @guess.score = (1 - (@guess.delta / 2016.to_f)) * 10000
    when 4 #date
      date = (params[:month] + "." + params[:day] + "." + params[:year]).to_date
      infodate = (@information.year.to_s + "." + @information.month.to_s + "." + @information.day.to_s).to_date
      @guess.delta = (date - infodate).abs
      @guess.score = 10000 - (@guess.delta % 10000)
      @guess.answer = params[:month].rjust(2, '0') + params[:day].rjust(2, '0') + params[:year]
    else
    end

    respond_to do |format|
      if @guess.save
        flash[:guess_id] = @guess.id #pass the id for the result page
        format.html { redirect_to action: "result", notice: 'Good guess!' }
        format.json { render :show, status: :created, location: @guess }
      else
        format.html { render :new }
        format.json { render json: @guess.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /guesses/1
  # PATCH/PUT /guesses/1.json
  def update
    respond_to do |format|
      if @guess.update(guess_params)
        format.html { redirect_to @guess, notice: 'Guess was successfully updated.' }
        format.json { render :show, status: :ok, location: @guess }
      else
        format.html { render :edit }
        format.json { render json: @guess.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guesses/1
  # DELETE /guesses/1.json
  def destroy
    @guess.destroy
    respond_to do |format|
      format.html { redirect_to guesses_url, notice: 'Guess was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guess
      @guess = Guess.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def guess_params
      params.require(:guess).permit(:information_id, :answer, :kind, :delta, :score, :user_id, :day, :month, :year)
    end
end
