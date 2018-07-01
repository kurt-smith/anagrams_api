# frozen_string_literal: true

module Dictionary
  Words ||= Zlib::GzipReader.open(Rails.root.join('vendor', 'dictionary', 'dictionary.txt.gz'), &:read).split(/\n/)
end
