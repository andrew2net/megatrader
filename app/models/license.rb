class License < ActiveRecord::Base
  has_many :license_logs, dependent: :delete_all
  belongs_to :product
  belongs_to :user, inverse_of: :licenses

  def resp_data(a)
    begin
      b = a.map { |el| inverse_transform el }
    rescue
      b = []
    end
    update key: key_gen
    reload
    b
  end

  private
  def key_gen
    ts = DateTime.now.to_s
    salt = Setting.find_by name: 'Salt'
    Digest::MD5.hexdigest ts + salt.value.to_s
  end

  def inverse_transform(a)
    width=a[0].size
    height=a.size
    b=Array.new(height)
    b.each_index{|i| b[i]=Array.new(width)}
    (0...height).each do |y|
      (0...width).each do |x|
        x2 = (x-x/(width/2+width%2)*width).abs*2-x/(width/2+width%2)
        y2 = (y-y/(height/2+height%2)*height).abs*2-y/(height/2+height%2)
        b[y2][x2]=a[y][x]
      end
    end
    b
  end
end
