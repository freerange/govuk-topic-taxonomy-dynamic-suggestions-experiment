class Taxon < ApplicationRecord
  def parent
    Taxon.find_by(base_path: self.parent_base_path)
  end

  def breadcrumbs
    taxon = self
    taxons = [taxon]
    while taxon.parent.present?
      taxon = taxon.parent
      taxons << taxon
    end
    taxons
  end
end
