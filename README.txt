# Class GuiParticleEmitter

An implementation of a ParticleEmitter for Guis. The object may emit particles on a method call
or may be set enabled to emit particles given a rate.



Subclasses:
  Emitter implements the function of emitting particles.

  Particle implements handling the movement and construction of ImageLabels.

  ParticlesHandler implements iterating through all particles to trigger movements.

  LoopEmitter represents the GuiParticleEmitter in a LoopEmittersHandler to emit given a rate.



Example usage:
  local guiParticleEmitter = GuiParticleEmitter.New()

  guiParticleEmitter.AnchorPoint = Vector2.new(.5, .5)
  guiParticleEmitter.LifeTime = NumberRange.new(3, 3)
  guiParticleEmitter.Parent = script.Parent
  guiParticleEmitter.Position = UDim2.new(.5, 0, .5, 0)
  guiParticleEmitter.Rate = 25
  guiParticleEmitter.RotSpeed = 90
  guiParticleEmitter.Size = UDim2.new(0, 40, 0, 40)
  guiParticleEmitter.Speed = NumberRange.new(-50, -50)
  guiParticleEmitter.SpreadAngle = 180
  guiParticleEmitter.ZIndex = 1

  guiParticleEmitter:SetEnabled(true)
  wait(10)
  guiParticleEmitter:SetEnabled(false)



Public Property Summaries:
  Property			  Type and Description

  Acceleration		Vector2
                  The change in X and Y speed per second

  AnchorPoint			Vector2
                  The AnchorPoint of the Particle ImageLabels

  Color				    Color3
                  The overlay Color of the Particle ImageLabels

  FrontDirection	Number
                  The emit angle

  IsEnabled		  	Boolean - READONLY
                  True if the LoopEmitter is enabled

  LifeTime		  	NumberRange
                  The minimum and maximum time a particle may exist before being removed

  Parent			  	Instance
                  The parent of the Particle ImageLabels

  Position		  	UDim2
                  The center of the emissions

  Rate			    	Number
                  The number of particles to emit per second

  RotSpeed	  		Number
                  The speed the angle of the Particle ImageLabels are changed per second

  Size				    UDim2
                  The size of the Particle ImageLabels

  SizeConstraint	Enum.SizeConstraint
                  This property works in conjunction with the Size property to determine the screen size of the Particle ImageLabel

  Speed			    	NumberRange
                  The minimum and maximum speed in pixels a Particle ImageLabel may move

  SpreadAngle			Number
                  The amplitude of the range the angle of emission may change
                  e.g. SpreadAngle=45 and Angle=30, the emission will be between -15 to 75 degrees

  Texture			  	String
                  The assetid of the Image for the Particle ImageLabel
                  e.g. "rbxasset://textures/particles/sparkles_main.dds"

  Transparency		NumberSequence - TODO
                  The minimum and maximum transparency of the Particle ImageLabel

  ZIndex			  	Integer
                  The ZIndex of the Particle ImageLabel



Constructors and Summaries:
  GuiParticleEmitter.New()
    Constructs a new GuiParticleEmitter with the default properties



Public Method Summaries:
  Method		 	Description and Parameters and Return Value

  SetEnabled	Enables or Disables the LoopEmitter
              @Param	enable	Boolean	True to enable the LoopEmitter

  Emit		 		Emits N particles
              @Param	count	  Integer	The number of particles to emit

  Clear				Removes all existing particles from this GuiParticleEmitter
    
