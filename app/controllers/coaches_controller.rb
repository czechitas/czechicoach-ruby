class CoachesController < ApplicationController
  before_action :set_coach, only: [:show, :edit, :update, :destroy]

  # GET /coaches
  # GET /coaches.json
  def index
    @coaches = Coach.all

    if filter = params[:skill_filter].presence
      @coaches = Coach.web(@coaches) if filter == "Web"
      @coaches = Coach.programming(@coaches) if filter == "Programming"
      @coaches = Coach.graphics(@coaches) if filter == "Graphics"
    end

    if filter = params[:city_filter].presence
      @coaches = @coaches.praha if filter == "Praha"
      @coaches = @coaches.brno if filter == "Brno"
      @coaches = @coaches.others if filter == "Others"
    end

    if query = params[:query].presence
      @coaches = @coaches.where("name ILIKE ? OR email ILIKE ? OR company ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%") 
    end
  end

  # GET /coaches/1
  # GET /coaches/1.json
  def show
  end

  # GET /coaches/new
  def new
    @coach = Coach.new
  end

  # GET /coaches/1/edit
  def edit
  end

  # POST /coaches
  # POST /coaches.json
  def create
    @coach = Coach.new(coach_params)

    respond_to do |format|
      if @coach.save
        format.html { redirect_to @coach, notice: 'Coach was successfully created.' }
        format.json { render :show, status: :created, location: @coach }
      else
        format.html { render :new }
        format.json { render json: @coach.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coaches/1
  # PATCH/PUT /coaches/1.json
  def update
    respond_to do |format|
      if @coach.update(coach_params)
        format.html { redirect_to @coach, notice: 'Coach was successfully updated.' }
        format.json { render :show, status: :ok, location: @coach }
      else
        format.html { render :edit }
        format.json { render json: @coach.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coaches/1
  # DELETE /coaches/1.json
  def destroy
    @coach.destroy
    respond_to do |format|
      format.html { redirect_to coaches_url, notice: 'Coach was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload
    if request.post?
      Coach.import_from_csv(params[:file])
      redirect_to coaches_url, notice: "Coaches were imported from the file."
    else
    end
  end

  def export
    send_file Coach.export_all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coach
      @coach = Coach.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def coach_params
      params.require(:coach).permit(:name, :city, :email, :company, skill_ids: [])
    end
end
