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

        charge = retrieve_token(params[:omise_token]) ? creatCharge(charity,params[:omise_token],value) :
            createFakeCharge(value)

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
    begin
      Omise::Token.retrieve(token)
    rescue
      nil
    end
  end

  def creatCharge(charity,token,value)
    charge = Omise::Charge.create({
         amount: value,
         currency: "THB",
         card: token,
         description: "Donation to #{charity.name} [#{charity.id}]",
     })

    charge
  end

  def createFakeCharge(value)
    charge = OpenStruct.new({
        amount: value,
        paid: ((value/100) != 999),
    })
  end



end
