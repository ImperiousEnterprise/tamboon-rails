class WebsiteController < ApplicationController
  def index
    @token = nil
  end

  def donate
    charity = params[:charity].to_s.downcase == "random" ? Charity.order("RANDOM()").first :
        Charity.find_by(id: params[:charity])
    if params[:omise_token].present?
      amount = params[:amount].blank? || params[:amount].to_f <= 20.00
      unless amount || !charity
        value = (params[:amount].to_f * 100).to_i
        if Rails.env.test?
          charge = OpenStruct.new({
              amount: value,
              paid: (params[:amount].to_i != 999),
          })
        else
          charge = Omise::Charge.create({
             amount: value,
             currency: "THB",
             card: params[:omise_token],
             description: "Donation to #{charity.name} [#{charity.id}]",
           })
        end
        if charge.paid
          charity.credit_amount(charge.amount)
          flash.notice = t(".success")
          redirect_to root_path
          return
        end
      end
    end

    @token = charity ? nil : retrieve_token(params[:omise_token])
    flash.now.alert = t(".failure")
    render :index
    return

  end

  private

  def retrieve_token(token)
    if Rails.env.test?
      OpenStruct.new({
        id: "tokn_X",
        card: OpenStruct.new({
          name: "J DOE",
          last_digits: "4242",
          expiration_month: 10,
          expiration_year: 2020,
          security_code_check: false,
        }),
      })
    else
      Omise::Token.retrieve(token)
    end
  end
end
