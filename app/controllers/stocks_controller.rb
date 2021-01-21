class StocksController < ApplicationController

  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      if @stock
        tracked_stock = Stock.check_db(params[:stock])
        if !tracked_stock.blank?
          tracked_stock.last_price = @stock.last_price
          tracked_stock.save
        end
        # respond_to allows for ajax
        respond_to do |format|
          format.js { render partial: 'users/result' }
        end
      else
        respond_to do |format|
          # flash.now will display without having do deal with full req/res cycle
          flash.now[:alert] = "Please enter a valid symbol to search"
          format.js { render partial: 'users/result' }
        end
      end
    else
        respond_to do |format|
          flash.now[:alert] = "Please enter a symbol to search"
          format.js { render partial: 'users/result' }
        end
    end
  end

end