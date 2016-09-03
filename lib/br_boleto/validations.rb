class CustomLengthValidator < ActiveModel::EachValidator
	def validate_each(record, attribute, value)
		is_value = max_value = min_value = nil
		max_value = options[:maximum].is_a?(Symbol) ? record.send(options[:maximum]).to_i : options[:maximum]
		min_value = options[:minimum].is_a?(Symbol) ? record.send(options[:minimum]).to_i : options[:minimum]
		is_value  = options[:is].is_a?(Symbol) ? record.send(options[:is]).to_i : options[:is]
		record.errors.add(attribute, :custom_length_maximum, count: max_value) if max_value && "#{record.try(attribute)}".strip.size > max_value
		record.errors.add(attribute, :custom_length_minimum, count: min_value) if min_value && "#{record.try(attribute)}".strip.size < min_value
		record.errors.add(attribute, :custom_length_is,      count: is_value ) if is_value  && "#{record.try(attribute)}".strip.size != is_value
	end
end

class CustomInclusionValidator < ActiveModel::EachValidator
	def validate_each(record, attribute, value)
		in_values = [options[:in].is_a?(Symbol) ? record.send(options[:in]) : options[:in]].flatten.compact.map(&:to_s)
		record.errors.add(attribute, :custom_inclusion, list: in_values.join(', ') ) if in_values.any?  && !"#{record.try(attribute)}".strip.in?(in_values)
	end
end
  