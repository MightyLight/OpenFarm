module Api
  class StagesController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:index, :show]

    def create
      @outcome = Stages::CreateStage.run(params, user: current_user)
      respond_with_mutation(:created)
    end

    def show
      stage = Stage.find(params[:id])
      # If this isn't nested, there seems to be a problem
      # with sometimes stages not being returned nested
      # (as happens with other parts of the API)
      render json: { stage: stage }
    end

    def update
      # UpdateStage is being funny, issue reported here:
      # https://github.com/cypriss/mutations/issues/85
      @outcome = Stages::UpdateStage.run(attributes: params[:stage],
                                         stage: Stage.find(params[:id]),
                                         user: current_user)
      respond_with_mutation(:ok)
    end

    def destroy
      @outcome = Stages::DestroyStage.run(params,
                                          user: current_user)
      respond_with_mutation(:no_content)
    end
  end
end
