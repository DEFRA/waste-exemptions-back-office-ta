# frozen_string_literal: true

Time::DATE_FORMATS[:time_on_day_month_year] = "%-l:%M%P on %-d %B %Y"
Date::DATE_FORMATS[:month_year] = "%B %Y"
Date::DATE_FORMATS[:day_month_year] = "%-d %B %Y"
Date::DATE_FORMATS[:year_month_day] = "%Y-%m-%d"
