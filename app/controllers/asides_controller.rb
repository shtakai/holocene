class AsidesController < ApplicationController
  before_action :set_aside, only: %i[show edit update destroy]
  before_action :set_chapter, only: %i[index new ]

  # GET /asides
  # GET /asides.json
  def index
    @asides = Aside.all
  end

  # GET /asides/1
  # GET /asides/1.json
  def show
    @chapter = @aside.chapter
  end

  # GET /asides/new
  def new
    @aside = Aside.new
    @aside.chapter = @chapter
    @scripted = @chapter.scripted
  end

  # GET /asides/1/edit
  def edit
    @chapter = @aside.chapter
  end

  # POST /asides
  # POST /asides.json
  def create
    @aside = Aside.new(aside_params)
    @chapter = @aside.chapter
    @scripted = @chapter.scripted

    respond_to do |format|
      if @aside.save
        format.html { redirect_to chapter_path(@chapter), notice: 'Aside was successfully created.' }
        format.json { render :show, status: :created, location: @aside }
      else
        format.html { render :new }
        format.json { render json: @aside.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /asides/1
  # PATCH/PUT /asides/1.json
  def update
    @chapter = @aside.chapter
    @scripted = @chapter.scripted
    respond_to do |format|
      if @aside.update(aside_params)
        format.html { redirect_to chapter_path(@chapter), notice: 'Aside was successfully updated.' }
        format.json { render :show, status: :ok, location: @aside }
      else
        format.html { render :edit }
        format.json { render json: @aside.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /asides/1
  # DELETE /asides/1.json
  def destroy
    @chapter = @aside.chapter
    @scripted = @chapter.scripted
    @aside.destroy
    respond_to do |format|
      format.html { redirect_to chapter_path(@chapter), notice: 'Aside was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_aside
    @aside = Aside.find(params[:id])
  end

  def set_chapter
    @chapter = Chapter.find(params[:chapter_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def aside_params
    params.require(:aside).permit(:name, :body, :chapter_id)
  end
end
