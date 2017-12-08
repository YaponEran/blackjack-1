module Facer
  FACES = %W[ʕ•ᴥ•ʔ (ಠ_ಠ) ('-') (ᵔᴥᵔ) (~_^) (◕‿◕✿) (¬‿¬) (>_<)
             (•◡•) (⚆_⚆) (ʘ‿ʘ) (¬_¬) (@‿@) (✿´‿`) (^_^) (o_O)
             (._.) (-_-) ($‿$) (*◡*) (`◡`) (+_+)  (#_#) >O.O<].freeze

  def random_face
    FACES.sample
  end

  def faces
    FACES
  end

  def change_face(n)
    FACES[n]
  end
end
