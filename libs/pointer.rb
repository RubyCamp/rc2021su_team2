class Pointer < Sprite
	def initialize(director)
		@director = director
		img = Image.new(10, 10, C_BLACK)
		super(Input.mouse_x, Input.mouse_y, img)
		@clicked_cards = []
	end

	def update
		self.x = Input.mouse_x
		self.y = Input.mouse_y
		return if @clicked_cards.empty?

		card = @clicked_cards.sort_by{|c| c.id }.last
		card.id = @director.deck_cards.map(&:id).sort.last + 1 #プレイヤーの手札の一個外側のインデックス(目次、配列の中の位置)
		
		card.open
		card.set_position(100 + card.id * 20, 30)

		@director.add_opened_card(card)
		@clicked_cards = []
	end

	def shot(card)
		if Input.mouse_push?(M_LBUTTON)
			@clicked_cards << card unless @director.locked?
		end
	end
end