class Card < Sprite
	attr_accessor :suit, :number
	attr_reader :id
	@@num = 0
	SUIT_FONT_SIZE = 24
	NUMBER_FONT_SIZE = 36
	SUIT_FONT = Font.new(SUIT_FONT_SIZE)
	NUMBER_FONT = Font.new(NUMBER_FONT_SIZE)
	SUIT_LABELS = {
		spade: { text: '♠', color: C_BLACK },
		dia: { text: '♦', color: C_RED },
		club: { text: '♣', color: C_BLACK },
		heart: { text: '♥', color: C_RED },
		god:{text:'G', color:C_YELLOW}
	}

	def initialize(id, x, y, suit, number,  director)
		@id = id
		self.suit = suit
		self.number = number
		@@num += 1
		@num = @@num
		@reverse_image = Image.load('images/reverse_card.png')
		@foreground_image = Image.load('images/foreground_card.png')
		@godkurahashi_image = Image.load('images/godkurahashi.png')
		label = SUIT_LABELS[self.suit]
			if label != 'god'.to_sym
				@foreground_image.draw_font(5, 5, label[:text], SUIT_FONT, label[:color])
				
			end
		
		char = number_char(self.number)
		char_width = NUMBER_FONT.get_width(char)
			if char != 'god'.to_sym
				@foreground_image.draw_font((@foreground_image.width - char_width) / 2, 30, char, NUMBER_FONT, C_BLACK)
			end
		super(x, y, @reverse_image)
		@director = director
	end

	def set_position(x,y)
		self.x = x
		self.y = y
	end

	def draw
		Window.draw(self.x, self.y, self.image)
	end

	def open
		if @num != 53
			self.image = @foreground_image
		else
			self.image = @godkurahashi_image
		end
	end

	def reverse
		self.image = @reverse_image
	end

	private

	def number_char(num)
		return 'A' if num == 1
		return 'J' if num == 11
		return 'Q' if num == 12
		return 'K' if num == 13 
		return ''  if num == 53
		return num.to_s
	end
end