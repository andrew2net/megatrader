# Licanse model
class License < ActiveRecord::Base
  has_many :license_logs, dependent: :delete_all
  belongs_to :product
  belongs_to :user, inverse_of: :licenses

  def resp_data(prod_id, aaa, kkk)
    b = if prod_id.to_i == 7
          transform aaa, kkk
        else aaa.map { |el| inverse_transform el }
        end
  rescue StandardError
    b = []
  ensure
    update key: key_gen
    reload
    b
  end

  def self.search_license(license:, prod_id:)
    if prod_id
      License.where(blocked: false, product_id: prod_id, text: license).first
    else
      License.where(blocked: false).find_by(text: license)
    end
  end

  private

  def key_gen
    ts = Time.now.to_s
    salt = Setting.find_by name: 'Salt'
    Digest::MD5.hexdigest ts + salt.value.to_s
  end

  def inverse_transform(a)
    width = a[0].size
    height = a.size
    b = Array.new(height)
    b.each_index { |i| b[i] = Array.new(width) }
    (0...height).each do |y|
      (0...width).each do |x|
        x2 = (x - x / (width / 2 + width % 2) * width).abs * 2 - x / (width / 2 + width % 2)
        y2 = (y - y/(height / 2 + height % 2) * height).abs * 2 - y / (height / 2 + height % 2)
        b[y2][x2] = a[y][x]
      end
    end
    b
  end

  def compute_hash_seed(hash_string)
    return 0 if hash_string == ''
    seed = 0
    (0...hash_string.size).each do |i|
      seed += hash_string[i].ord
    end
    seed
  end

  def permutation_transform(a, seed)
    return a if a.size <= 2
    b = Array.new(a.size)
    width = a.size
    base = 20
    base = width - 1 if base >= width
    count = 1 + seed % base
    (1..count).each do |step|
      b.each_index do |i|
        i2 = (i - i / (width / 2 + width % 2) * width).abs * 2 - i / (width / 2 + width % 2)
        b[i] = a[i2]
      end
      a.each_index { |i| a[i] = b[i - step] }
    end
    a
  end

  def transform(data, hash_string)
    cycle = 3
    seed = compute_hash_seed(hash_string)
    res = []
    data.each do |a|
      nc = a[1].to_i
      ic = a[0].to_i
      i = 0
      while (i < nc) && (i < cycle)
        order = Array.new(ic)
        (0...ic).each { |k| order[k] = k }
        order = permutation_transform(order, seed + i)
        res << order
        i += 1
      end
    end
    res
  end

# a=[[5,7],[7,2]]

# b=transform(a,"OHKSNVXMPL")
end
