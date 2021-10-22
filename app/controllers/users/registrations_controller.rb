# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :set_redemption_code, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params)

    if @redemption_code.present?
      resource.skip_confirmation!
      if resource.save
        begin
          create_redemption!
          if @redemption_code.trial_ends_at.present?
            resource.update!(trial_ends_at: @redemption_code.trial_ends_at)
          else
            resource.update!(
              processor: :fake_processor,
              processor_id: rand(1_000_000),
              pay_fake_processor_allowed: true
            )
            resource.subscribe(plan: @redemption_code.plan.processor_id)
          end
        rescue ActiveRecord::RecordInvalid => error
          resource.destroy
          redirect_to root_path, alert: error and return 
        end
      end
    else
      resource.save
      resource.update(trial_ends_at: 14.days.from_now)
    end
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end    
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:accepted_terms])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

  def set_redemption_code
    @redemption_code = RedemptionCode.find_by(value: params[:redemption_code])
  end

  def create_redemption!
    resource.create_redemption!(redemption_code: @redemption_code)
  end

end
