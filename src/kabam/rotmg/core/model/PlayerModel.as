package kabam.rotmg.core.model
{
   import com.company.assembleegameclient.appengine.SavedCharacter;
   import com.company.assembleegameclient.appengine.SavedCharactersList;
   import com.company.assembleegameclient.appengine.SavedNewsItem;
   import com.company.assembleegameclient.parameters.Parameters;
   import kabam.rotmg.account.core.Account;
   import org.osflash.signals.Signal;
   
   public class PlayerModel
   {
      public const creditsChanged:Signal = new Signal(int);
      public const fameChanged:Signal = new Signal(int);
      public var charList:SavedCharactersList;
      public var isInvalidated:Boolean;
      public var currentCharId:int;
      
      [Inject]
      public var account:Account;
      
      public function PlayerModel()
      {
         super();
         this.isInvalidated = true;
      }

      public function getMaxCharacters() : int
      {
         return this.charList.maxNumChars_;
      }
      
      public function setMaxCharacters(value:int) : void
      {
         this.charList.maxNumChars_ = value;
      }
      
      public function getCredits() : int
      {
         return this.charList.credits_;
      }
      
      public function changeCredits(credits:int) : void
      {
         this.charList.credits_ = this.charList.credits_ + credits;
         this.creditsChanged.dispatch(this.charList.credits_);
      }
      
      public function setCredits(credits:int) : void
      {
         if(this.charList.credits_ != credits)
         {
            this.charList.credits_ = credits;
            this.creditsChanged.dispatch(credits);
         }
      }
      
      public function getFame() : int
      {
         return this.charList.fame_;
      }

      public function changeFame(fame:int) : void
      {
         this.charList.fame_ = this.charList.fame_ + fame;
         this.fameChanged.dispatch(this.charList.fame_);
      }
      
      public function setFame(fame:int) : void
      {
         if(this.charList.fame_ != fame)
         {
            this.charList.fame_ = fame;
            this.fameChanged.dispatch(fame);
         }
      }
      
      public function getCharacterCount() : int
      {
         return this.charList.numChars_;
      }
      
      public function getCharById(characterId:int) : SavedCharacter
      {
         return this.charList.getCharById(characterId);
      }
      
      public function deleteCharacter(characterId:int) : void
      {
         var char:SavedCharacter = this.charList.getCharById(characterId);
         var i:int = this.charList.savedChars_.indexOf(char);
         if(i != -1)
         {
            this.charList.savedChars_.splice(i,1);
            this.charList.numChars_--;
         }
      }
      
      public function getAccountId() : int
      {
         return this.charList.accountId_;
      }
      
      public function hasAccount() : Boolean
      {
         return this.charList.accountId_ != -1;
      }
      
      public function getNumStars() : int
      {
         return this.charList.numStars_;
      }
      
      public function getGuildName() : String
      {
         return this.charList.guildName_;
      }
      
      public function getGuildRank() : int
      {
         return this.charList.guildRank_;
      }

      public function getTotalFame() : int
      {
         return this.charList.totalFame_;
      }
      
      public function getNextCharId() : int
      {
         return this.charList.nextCharId_;
      }
      
      public function getCharacterById(id:int) : SavedCharacter
      {
         var savedChar:SavedCharacter = null;
         for each(savedChar in this.charList.savedChars_)
         {
            if(savedChar.charId() == id)
            {
               return savedChar;
            }
         }
         return null;
      }
      
      public function getCharacterByIndex(i:int) : SavedCharacter
      {
         return this.charList.savedChars_[i];
      }
      
      public function getNews() : Vector.<SavedNewsItem>
      {
         return this.charList.news_;
      }

      public function getName() : String
      {
         return this.charList.name_;
      }
      
      public function setName(value:String) : void
      {
         this.charList.name_ = value;
      }

      public function hasAvailableCharSlot() : Boolean
      {
         return this.charList.hasAvailableCharSlot();
      }
      
      public function getAvailableCharSlots() : int
      {
         return this.charList.availableCharSlots();
      }
      
      public function getSavedCharacters() : Vector.<SavedCharacter>
      {
         return this.charList.savedChars_;
      }
      
      public function getCharStats() : Object
      {
         return this.charList.charStats_;
      }
      
      public function getBestFame(objectType:int) : int
      {
         return this.charList.bestFame(objectType);
      }
      
      public function getBestLevel(unlockType:int) : int
      {
         return this.charList.bestLevel(unlockType);
      }
      
      public function setCharacterList(savedCharactersList:SavedCharactersList) : void
      {
         this.charList = savedCharactersList;
      }
   }
}
