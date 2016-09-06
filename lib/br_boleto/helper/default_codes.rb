module BrBoleto
	module Helper
		module DefaultCodes

			# "Espécie do Título :
			def get_especie_titulo(code)
				"#{code}".adjust_size_to(2, '0', :right)
				equivalent_especie_titulo[code] || '99'
			end
			def equivalent_especie_titulo
				{
					'01' => '01', #  Duplicata Mercantil
					'02' => '02', #  Nota Promissória
					'03' => '03', #  Nota de Seguro
					'05' => '05', #  Recibo
					'06' => '06', #  Duplicata Rural
					'08' => '08', #  Letra de Câmbio
					'09' => '09', #  Warrant
					'10' => '10', #  Cheque
					'12' => '12', #  Duplicata de Serviço
					'13' => '13', #  Nota de Débito
					'14' => '14', #  Triplicata Mercantil
					'15' => '15', #  Triplicata de Serviço
					'18' => '18', #  Fatura
					'20' => '20', #  Apólice de Seguro
					'21' => '21', #  Mensalidade Escolar
					'22' => '22', #  Parcela de Consórcio
					'99' => '99', #  Outros"
				}
			end
		end
	end
end