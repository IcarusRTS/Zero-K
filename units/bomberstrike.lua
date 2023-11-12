return { bomberstrike = {
  name                = [[Penguin]],
  description         = [[Tactical Strike Bomber]],
  brakerate           = 0.4,
  builder             = false,
  buildPic            = [[bomberstrike.png]],
  canFly              = true,
  canGuard            = true,
  canMove             = true,
  canPatrol           = true,
  canSubmerge         = false,
  category            = [[FIXEDWING]],
  collide             = false,
  collisionVolumeOffsets = [[0 2 0]],
  collisionVolumeScales  = [[50 16 80]],
  collisionVolumeType    = [[ellipsoid]],
  corpse              = [[DEAD]],
  cruiseAltitude      = 160,

  customParams        = {
    reallyabomber    = [[1]],
    reammoseconds    = [[20]],
    refuelturnradius = [[150]],
    modelradius      = [[10]],
    okp_damage       = 340, -- Not perfectly reliable
    can_set_target   = [[1]],
  },

  explodeAs           = [[GUNSHIPEX]],
  floater             = true,
  footprintX          = 3,
  footprintZ          = 3,
  health              = 900,
  iconType            = [[bomberskirm]],
  maxAcc              = 0.5,
  maxAileron          = 0.025,
  maxBank             = 0.55,
  maxElevator         = 0.01,
  maxRudder           = 0.007,
  maxFuel             = 1000000,
  metalCost           = 220,
  noAutoFire          = false,
  noChaseCategory     = [[TERRAFORM FIXEDWING SATELLITE GUNSHIP]],
  objectName          = [[bomberstrike.s3o]],
  script              = [[bomberstrike.lua]],
  selfDestructAs      = [[GUNSHIPEX]],

  sfxtypes            = {},
  sightDistance       = 780,
  speed               = 252,
  turnRadius          = 500,
  workerTime          = 0,

  weapons             = {
    {
      def                = [[MISSILE]],
      badTargetCategory  = [[FIXEDWING]],
      mainDir            = [[0 0 1]],
      maxAngleDif        = 90,
      onlyTargetCategory = [[FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER SINK SUB]],
    },
  },


  weaponDefs          = {
  
    MISSILE = {
      name                    = [[Heavy Missiles]],
      areaOfEffect            = 48,
      cegTag                  = [[missiletrailyellow]],
      collideFriendly         = false,
      craterBoost             = 1,
      craterMult              = 2,

      customparams            = {
        burst = Shared.BURST_RELIABLE,
        reammoseconds = "autogenerated in posts",
      },

      damage                  = {
        default = 180,
      },

      fireStarter             = 70,
      fixedlauncher           = true,
      flightTime              = 3,
      impulseBoost            = 0.75,
      impulseFactor           = 0.3,
      interceptedByShieldType = 2,
      model                   = [[wep_m_dragonsfang.s3o]],
      projectiles             = 2,
      range                   = 550,
      reloadtime              = 1,
      smokeTrail              = true,
      soundHit                = [[explosion/ex_med5]],
      soundHitVolume          = 8,
      soundStart              = [[weapon/missile/missile_fire9_heavy]],
      soundStartVolume        = 7,
      startVelocity           = 300,
      texture2                = [[lightsmoketrail]],
      tolerance               = 4000,
      tracks                  = true,
      trajectoryHeight        = 0,
      turnRate                = 13000,
      turret                  = true,
      waterweapon             = true,
      weaponAcceleration      = 80,
      weaponType              = [[MissileLauncher]],
      weaponVelocity          = 400,
    },
    
  },


  featureDefs         = {

    DEAD  = {
      blocking         = true,
      featureDead      = [[HEAP]],
      footprintX       = 2,
      footprintZ       = 2,
      object           = [[bomberstrike_dead.s3o]],
    },

    HEAP  = {
      blocking         = false,
      footprintX       = 2,
      footprintZ       = 2,
      object           = [[debris2x2c.s3o]],
    },

  },

} }
