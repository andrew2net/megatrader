FactoryGirl.define do
  factory :license do
    email 'person@example.com'
    text %{Nw93vQRvG0o+6CevyvMcT+8jSp8ACynVutGhM8wPZa1j/DrmIRcDqz7b2NPRtkjl52zyN0axnCVQfFvCLtXGHVJbHSdWhpGM1YYPRtcZKrgmwbwzL2e2rVOoH4QDmcrYIwHMYydt5fUJknrs8I4WZq5uT10DO/FQ8GuEdMO4MLLkfbIl58l4U1BWX9uLQx9g7tZXn03ACVr/r2qWCNvH87J41oRFzRn51nrGg0WNz6/jqBlpmjHmoGpEFlGWUBsJ}

    factory :license_with_logs do
      after(:create) do |license|
        create_list :license_log, 5, license: license
      end
    end
  end

end
