class Characters::CharacterFeatsController < ApplicationController
  include CharacterScoped

  before_action :set_feat, only: %i[ destroy ]

  def new
    @feat         = @character.character_feats.build
    @class_names  = @character.character_classes.pluck(:name)
  end

  def create
    @feat = @character.character_feats.build(feat_params)

    if @feat.save
      redirect_to character_inventory_items_path(@character), notice: "Feat added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @feat.destroy!
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@feat) }
      format.html         { redirect_to character_inventory_items_path(@character), notice: "Feat removed." }
    end
  end

  private
    def set_feat
      @feat = @character.character_feats.find(params[:id])
    end

    def feat_params
      params.expect(character_feat: [ :name, :description, :source, :feat_type, :origin ])
    end
end
