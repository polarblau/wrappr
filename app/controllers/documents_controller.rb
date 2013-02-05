class DocumentsController < ApplicationController
  respond_to :html, :js
  before_filter :find_document, :except => :new

  def edit
  end

  def new
    document = current_user.documents.create!
    redirect_to document_url(document)
  end

  def update
    @document.update_attributes params[:document]
    respond_to do |format|
      format.html { respond_with @document }
      format.js   { head :ok               }
    end
  end

private

  def find_document
    @document = Document.find_by_random_id params[:random_id]
    unless @document.creator == current_user || @document.shared?
      raise ActiveRecord::RecordNotFound
    end
  end
end
