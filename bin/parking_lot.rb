# !usr/bin/env ruby
require 'singleton'

class ParkingLot
	include Singleton

	attr_accessor :total_slots, :total_parking_tickets

	def initialize(number_of_slots = 0)
		@total_slots           = send(:create_slots, number_of_slots)
		@total_parking_tickets = []
	end

	def create_parking_lot(number_of_slots)
		create_slots(number_of_slots)
	end


	def create_slots(number_of_slots = 0)
		number_of_slots = number_of_slots.to_i
		@total_slots = (1..number_of_slots).to_a.inject([]) do |total_slots, slot_number|
			total_slots << Slot.new(slot_number)
			total_slots
		end
		print "Created a parking lot with #{number_of_slots} slots\n" if number_of_slots > 0
	end

	def park(car_number_plate, car_colour)
		car               = car.is_a?(Car) ? car : Car.get_new_car(car_number_plate, car_colour)
		nearest_free_slot = check_if_free_slot_available
		@total_parking_tickets << create_parking_ticket(car, nearest_free_slot.slot_number)
		update_slot(nearest_free_slot, :allocated)
		print "Allocated slot number: #{nearest_free_slot.slot_number}\n"
	end

	def leave(slot_number)
		raise "All slots are free" if alloted_slots.empty?
		slot = alloted_slots.find{|slot| slot.slot_number.eql?(slot_number.to_i)}
		raise "Invalid slot number" if slot.nil?
		slot = update_slot(slot, :free)
		update_ticket_of_slot(slot, :out)
		print "Slot number #{slot_number} is free\n"
	end

	def free_slots
		total_slots.select{|slot| slot.free?}
	end

	def alloted_slots
		total_slots.select{|slot| slot.allocated?}
	end

	def nearest_free_slot
		free_slots.min_by(&:slot_number)
	end

	def status
		tickets_details_having_alloted_slot
	end

	def tickets_having_alloted_slot
		total_parking_tickets.select { |parking_ticket| parking_ticket.free?}
	end

	def tickets_details_having_alloted_slot
		parking_tickets = tickets_having_alloted_slot
		print "Slot No.    Registration No    Colour\n"
		parking_tickets.each do |parking_ticket|
			print "#{parking_ticket.slot_number}           #{parking_ticket.registration_number}      #{parking_ticket.car_colour}\n"
		end
	end

	def registration_numbers_for_cars_with_colour colour 
		registration_numbers = tickets_having_alloted_slot.
							   select { |ticket|  ticket.car_colour == colour }.
							   map { |ticket| ticket.registration_number }
		raise "Not found" if registration_numbers.empty? 
		print "#{registration_numbers.join(', ')}\n"
	end

	def slot_numbers_for_cars_with_colour(colour)
		slot_numbers = tickets_having_alloted_slot.
							   select { |ticket|  ticket.car_colour == colour }.
							   map { |ticket| ticket.slot_number }
	    raise "Not found" if slot_numbers.empty?
		print "#{slot_numbers.join(', ')}\n"
	end

	def slot_number_for_registration_number(registration_number)
		ticket = tickets_having_alloted_slot.find { |ticket|  ticket.registration_number == registration_number }
		raise "Not found" if ticket.nil?
		print "#{ticket.slot_number}\n"
	end

	private

	def check_if_free_slot_available
		return nearest_free_slot unless free_slots.empty?
		raise "Sorry, parking lot is full"
	end

	def create_parking_ticket(car, slot_number)
		ParkingTicket.new(car, slot_number)
	end

	def update_slot(slot, status)
		case status
		when :allocated then slot.allocated!;
		when :free      then slot.free!;
		else
			raise "Wrong slot status."
		end
	end

	def update_ticket_of_slot(slot, status)
		parking_ticket = total_parking_tickets.
						 find do |parking_ticket| 
						 	parking_ticket.slot_number.eql?(slot.slot_number)
						 end
		case status
		when :in  then parking_ticket.in!
		when :out then parking_ticket.out!
		else
			raise "Wrong ticket status."
		end
	end


end

class Slot

	SLOT_STATUSES = { free: "free", allocated: "allocated" }

	attr_accessor :status, :slot_number

	def initialize(slot_number)
		@status      = SLOT_STATUSES[:free]
		@slot_number = slot_number
	end

	def free?
		@status.eql?(SLOT_STATUSES[:free])
	end

	def allocated?
		@status.eql?(SLOT_STATUSES[:allocated])
	end

	def free!
		@status = SLOT_STATUSES[:free]
		self
	end

	def allocated!
		@status = SLOT_STATUSES[:allocated]
		self
	end

end

class ParkingTicket
	attr_accessor :registration_number, :car_colour, :slot_number, :status

	TICKET_STATUS = { in: "in", out: "out" }

	def initialize(car, slot_number)
		@registration_number = car.number_plat
		@car_colour          = car.colour
		@slot_number         = slot_number
		@status              = TICKET_STATUS[:in]
	end

	def in!
		@status = TICKET_STATUS[:in]
	end

	def out!
		@status = TICKET_STATUS[:out]
	end

	def free?
		@status.eql?(TICKET_STATUS[:in])
	end

	def allocated?
		@status.eql?(TICKET_STATUS[:out])
	end

end

class Car
	attr_accessor :number_plat, :colour

	def initialize(args)
	    args.each do |k,v|
	      instance_variable_set("@#{k}", v) unless v.nil?
	    end
	end

	def self.get_new_car(number_plat, colour)
		new({ number_plat: number_plat, colour: colour })
	end
end

def execute_line(line)
	line_data   = line.split(' ')
	method_name = line_data.shift
	args        = line_data

	begin
		if args.empty?
			exit(true) if method_name.eql?("exit")
	 		ParkingLot.instance.send(method_name) 
		else
	 		ParkingLot.instance.send(method_name, *args) 
		end
	rescue StandardError => e
		print "#{e.message}\n"
	end
end

# GETS INPUT
if ARGV.length > 0
	filename = ARGV.first.chomp
	File.foreach("#{filename}") do |line|
		execute_line(line)
	end
else
	while (command = STDIN.gets.chomp()) != 'exit'
		execute_line(command)
	end
end


 