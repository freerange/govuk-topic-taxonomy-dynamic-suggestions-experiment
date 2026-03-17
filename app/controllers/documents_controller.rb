class DocumentsController < ApplicationController
  def index
    @documents = Document.published.select(:id, :title)
  end

  def show
    @document = Document.find(params[:id])
    @similar_documents = @document.nearest_neighbors(:embedding, distance: 'cosine').published.first(5)
    @suggested_taxons = (@similar_documents.flat_map(&:taxons) - @document.taxons).group_by { |t| t['title'] }
  end

  def new
    @document = Document.new
  end

  def create
    text_to_embed = [document_params[:title], document_params[:body]].join(' ')
    embedding = RubyLLM.embed(
      text_to_embed,
      provider: 'openrouter',
      model: 'qwen/qwen3-embedding-4b',
      assume_model_exists: true
    )

    @document = Document.new(
      content_store_id: SecureRandom.uuid,
      draft: true,
      embedding: embedding.vectors,
      **document_params
    )

    if @document.save
      redirect_to document_path(@document)
    else
      flash.now[:errors] = @document.errors.full_messages
      render :new
    end
  end

  private

  def document_params
    params.expect(document: [:title, :body])
  end
end
