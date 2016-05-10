module BrBoleto
	module Helper
		module FormatValue
			extend self

			def string_to_float(value)
				return 0 if value.blank?
				return value if value.is_a?(Numeric)
				value.insert(value.size-2, '.').to_f
			end

			def string_to_date(value, format = "%d%m%Y")
				return value if value.is_a?(Date)
				begin Date.strptime(value, format) rescue nil end
			end			
		end
	end
end