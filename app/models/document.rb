class Document < ApplicationRecord
  has_neighbors :embedding

  def govuk_url
    "https://www.gov.uk#{base_path}"
  end
end
