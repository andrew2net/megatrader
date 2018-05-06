json.call(license, :id, :product_id, :text, :blocked, :key, :date_end,
          :key_errors)
json.call(license.user, :email, :errors)
