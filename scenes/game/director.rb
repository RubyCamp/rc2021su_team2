module Game
  class Director < DirectorBase
    attr_accessor :deck_cards, :opened_cards, :hand_cards
    WAIT_FRAMES = 60

    def initialize
      @bg = Image.load('images/bg_game.jpg')
      @suits = [:spade, :club, :dia, :heart, :god]
      @bgm = Sound.new("sounds/opening.mid") #BGM選曲
      @dici = Sound.new("sounds/se5.wav") #効果音選曲
      @bgm.set_volume( 225, time=0 )


      @pointer = Pointer.new(self)
      @flag = 0
    end

    def reload
      self.deck_cards = []
      init_cards
      slice_cards
      @wait = WAIT_FRAMES
      @opened_cards = []
      @player_id = 1
      @flag = 0
      @bgm.play
    end

    #デッキから手札に配るメソッド
    def slice_cards
      @hand_cards = @deck_cards.slice(0..@deck_cards.size/2)
      @enemy_cards = @deck_cards.slice((@deck_cards.size/2+1)..@deck_cards.size)
      throw_duplicated_cards
      @hand_cards.each_with_index do |card,index|
        if card
          card.open
          card.set_position(100 + index * 70, 600)
        end
      end

      @enemy_cards.each_with_index do |card,index|
        if card
          card.set_position(100 + index * 70, 30)
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
      game_judge
      @deck_cards = @hand_cards + @enemy_cards   
      self.deck_cards.sort_by{|c| c.id }.each(&:draw)
      @pointer.update
      Sprite.update(self.deck_cards)
      Sprite.check(@pointer, @enemy_cards)
      
      if @player_id == 1
        @hand_cards.each_with_index do |card,index|
          if card
           card.open
           card.set_position(100 + index * 70, 600)
          end
        end

        if @opened_cards.size == 1
          if @flag == 0
            @hand_cards.concat(@opened_cards)
            @enemy_cards.delete(@opened_cards.first)
            @flag = 1
          end

          if isthrow?
            opened_card = @opened_cards.first
            @hand_cards.delete(opened_card)
            hand_card = @hand_cards.detect{|c| c.number == opened_card.number}
            @hand_cards.delete(hand_card)
          end

          if @wait > 0 
            @wait -= 1
            return
          end

          @flag = 0
          @wait = WAIT_FRAMES
         change_player
         @opened_cards = []
        end
     else 
       if @flag == 0 
          selected_card = @hand_cards.sample # sleced_card: card or nil
          @hand_cards.delete(selected_card)
          if selected_card.suit == :god 
            selected_card.reverse
          end

          index = @enemy_cards.size + 1           #相手の手札の一個外側のインデックス(目次、配列の中の位置)
    		  selected_card.set_position(100 + index * 70, 30)
          @flag = 1
       end

        if selected_card != nil #nilじゃないことを証明
          @opened_cards.push(selected_card)
          @enemy_cards.push(selected_card) #配列enemy_cardsにランダムで選択されたselected_cardを追加
          if isthrow?
            opened_card = @opened_cards.first
            @enemy_cards.delete(opened_card)
            enemy_card = @enemy_cards.detect{|c| c.number == opened_card.number}
            @enemy_cards.delete(enemy_card)
          end
        end

        if @wait > 0 
          @wait -= 1
          return
        end

        @flag = 0
        @wait = WAIT_FRAMES
        change_player
        @opened_cards = []
        @enemy_cards.shuffle!
        @enemy_cards.each_with_index do |card,index|
          if card
            card.set_position(100 + index * 70, 30)
          end
        end
      end
      
    end

    def add_opened_card(card)
      return if @opened_cards.size == 1 #カードを一枚めくる
      return if @opened_cards.include?(card)
      @opened_cards << card
      @dici.play
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

      @card_numbers = @comper_cards.map{|c| c.number}
      return @card_numbers.uniq.size != @card_numbers.size
    end 

    def throw_duplicated_cards
      numbers_cards = @hand_cards.group_by{|c|c.number}
      numbers_cards.each do |number, cards|
        if cards.size >= 2 
          if cards.size % 2 == 0
            @hand_cards = @hand_cards - cards
          else 
            cards.pop
            @hand_cards = @hand_cards - cards
          end
        end
      end

      numbers_cards = @enemy_cards.group_by{|c|c.number}
      numbers_cards.each do |number, cards|
        if cards.size >= 2
          if cards.size % 2 == 0
            @enemy_cards = @enemy_cards - cards
          else
            cards.pop
            @enemy_cards = @enemy_cards - cards
          end
        end
      end
    end

    def game_judge
      if @hand_cards.size == 1
        if @hand_cards.first.suit == :god 
         win_director = Scene.get(:win)
         Scene.move_to(:win)
        end
      end
      if @hand_cards.size == 0
        lose_director = Scene.get(:lose)
        Scene.move_to(:lose)
      end
    end
  end
end
