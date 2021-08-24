module Game
  class Director < DirectorBase
    attr_accessor :deck_cards, :opened_cards


    WAIT_FRAMES = 60

    def initialize
      @bg = Image.load('images/bg_game.png')
      @suits = [:spade, :club, :dia, :heart, :god]
     
      @pointer = Pointer.new(self)
    end

    def reload
      self.deck_cards = []
      id = 1
      @suits.each do |suit|
        if suit != "god".to_sym
          1.upto(13) do |n|
            @deck_cards << Card.new(id, rand(730) + 20, rand(390) + 10, suit, n, "55", self)
            id += 1
          end
        end      
      end
      @deck_cards << Card.new(id, 30 , 30 , :god, 53, 55, self)
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
      if @wait > 0 && @opened_cards.size == 2
        @wait -= 1
        return
      end
      if @opened_cards.size == 2
        if judgement
          @opened_cards.each do |c|
            self.deck_cards.delete(c)
            
          end
        else
          @opened_cards.each(&:reverse)
          change_player
        end
        @opened_cards = []
        @wait = WAIT_FRAMES
      end
      if self.deck_cards.size == 0
        win_director = Scene.get(:win)
        #if @score[1] > @score[2]
         # win_director.winner = 1
        #elsif
         # @score[1] < @score[2]
          #win_director.winner = 2
        #end
        Scene.move_to(:win)
      end
    end

    def add_opened_card(card)
      return if @opened_cards.size == 2
      return if @opened_cards.include?(card)
      @opened_cards << card
    end

    def locked?
      @opened_cards.size == 2 && @wait > 0
    end

    private

    def change_player
      if @player_id == 1
        @player_id = 2
      else
        @player_id = 1
      end
    end

    def judgement
      c1 = @opened_cards[0]
      c2 = @opened_cards[1]
      c1.number == c2.number
    end
    
    
    #def draw_score
     # y_pos = SCORE_Y
      #@score.each do |pid, score|
       # color = C_BLACK
        #color = C_RED if pid == @player_id
        #Window.draw_font(SCORE_X, y_pos, "P#{pid}: #{score}", SCORE_FONT, color: color)
        #y_pos += SCORE_GAP
      #end
    #end
    
  end
end
