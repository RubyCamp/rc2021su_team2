module Game
  class Director < DirectorBase
    attr_accessor :deck_cards, :opened_cards, :hand_cards

    WAIT_FRAMES = 60

    def initialize
      @bg = Image.load('images/bg_game.png')
      @suits = [:spade, :club, :dia, :heart, :god]

#追加分
# @cards = init_cards

      @pointer = Pointer.new(self)
    end

    def reload
      self.deck_cards = []
      
      init_cards

      slice_cards

      @wait = WAIT_FRAMES
      @opened_cards = []
      @player_id = 1
      
    end

    #デッキから手札に配るメソッド
    def slice_cards

      @hand_cards = @deck_cards.slice(0..@deck_cards.size/2)
      @enemy_cards = @deck_cards.slice(@deck_cards.size/2..@deck_cards.size)
      @hand_cards.each_with_index do |card,index|
        if card
          card.set_position(100 + index * 20, 30)
        end
      end
      @enemy_cards.each_with_index do |card,index|

        if card
          card.set_position(100 + index * 20, 600)
        end
      end

    end
    #シャフルメソッド完成
    def init_cards
      self.hand_cards = []
      id=1
      @suits.each do |suit|
        if suit != "god".to_sym
          1.upto(13) do |n|
            @deck_cards << Card.new(id, Window.width/2 ,  Window.height/2 , suit, n, self)
       
            id += 1
          end
        end      
      end

      

      @deck_cards << Card.new(id, Window.width/2 , Window.height/2 , :god, 53, self)
      @deck_cards.shuffle!
      @wait = WAIT_FRAMES

      @opened_cards = []
      @player_id = 1
    end
    

    def play
      Window.draw(0, 0, @bg)     
      self.deck_cards.sort_by{|c| c.id }.each(&:draw)

      @pointer.update
      Sprite.update(self.deck_cards)
      Sprite.check(@pointer, self.deck_cards)
      if @wait > 0 && @opened_cards.size == 1
        @wait -= 1
        return
      end

      if @player_id == 1
        if @opened_cards.size == 1
          @hand_cards.concat(@opened_cards)
      
          if isthrow? 
            @hand_cards.each do |c|
            self.hand_cards.delete(c)
            end
          end

          change_player
         @opened_cards = []
         @wait = WAIT_FRAMES
       end

      else
        selected_card = @hand_cards.sample # sleced_card: card or nil
        @hand_cards.delete(selected_card)

        if selected_card != nil #nilじゃないことを証明
          @enemy_cards.push(selected_card) #配列enemy_cardsにランダムで選択されたselected_cardを追加
          
          if isthrow?
            @enemy_cards.each do |c| 
              @enemy_cards.delete(c)
            end
          end

          change_player
          @wait = WAIT_FRAMES
        end
      end
    
      if self.deck_cards.size == 0
        win_director = Scene.get(:win)
        Scene.move_to(:win)
      end
    end

    def add_opened_card(card)
      return if @opened_cards.size == 1 #カードを一枚めくる
      return if @opened_cards.include?(card)
      @opened_cards << card
    end

    def locked?
      @opened_cards.size == 1 && @wait > 0
    end

    private

    def change_player
      if @player_id == 1
        @player_id = 2
      else
        @player_id = 1
      end
    end
    
    #カードを捨てるメソッド
    def isthrow?
      if @player_id == 1
        @comper_cards = @hand_cards
      else
        @comper_cards = @enemy_cards
      end
       @temp_cards = @comper_cards.map{|c| c.id}
       @temp_cards.uniq
       @temp_cards != @comper_cards.each{|c| c.id}
      
    end 
  end
end
