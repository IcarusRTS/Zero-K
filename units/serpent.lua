unitDef = {
  unitname            = [[serpent]],
  name                = [[Serpent]],
  description         = [[Sniper Submarine]],
  acceleration        = 0.1,
  activateWhenBuilt   = true,
  bmcode              = [[1]],
  brakeRate           = 0.3,
  buildCostEnergy     = 2000,
  buildCostMetal      = 2000,
  builder             = false,
  buildPic            = [[serpent.png]],
  buildTime           = 2000,
  canAttack           = true,
  canGuard            = true,
  canMove             = true,
  canPatrol           = true,
  canstop             = [[1]],
  category            = [[SUB FIREPROOF]],
  collisionVolumeOffset = [[0 0 0]],
  collisionVolumeScales = [[30 20 70]],
  collisionVolumeTest   = 1,
  collisionVolumeType   = [[box]],
  corpse              = [[DEAD]],

  customParams        = {
    description_fr = [[Sous-Marin Artilleur]],
    fireproof      = [[1]],
    helptext       = [[The Serpent is truly a nightmare, for its long-range, deadly accurate, high lethality heavy torpedoes can sink almost any ship in a few shots. It is however extremely expensive and not particularly agile.]],
    helptext_fr    = [[Le Serpent est un véritable cauchemard, grâce r ses torpilles haute vélocité r charge creuse, il peut couler depuis de les profondeurs nimporte quel navire ennemi. Relativement lent et peu blindé, sa portée lui permet de rester loin des combats.]],
  },

  defaultmissiontype  = [[Standby]],
  explodeAs           = [[BIG_UNITEX]],
  footprintX          = 3,
  footprintZ          = 3,
  iconType            = [[submarine]],
  idleAutoHeal        = 5,
  idleTime            = 1800,
  maneuverleashlength = [[640]],
  mass                = 1500,
  maxDamage           = 2600,
  maxVelocity         = 2.85,
  minCloakDistance    = 75,
  minWaterDepth       = 15,
  movementClass       = [[UBOAT3]],
  moveState           = 0,
  noAutoFire          = false,
  noChaseCategory     = [[TERRAFORM FIXEDWING SATELLITE HOVER]],
  objectName          = [[serpent]],
  script			  = [[serpent.lua]],
  seismicSignature    = 4,
  selfDestructAs      = [[BIG_UNITEX]],
  side                = [[ARM]],
  sightDistance       = 660,
  smoothAnim          = true,
  sonarDistance       = 350,
  steeringmode        = [[1]],
  TEDClass            = [[WATER]],
  turninplace         = 0,
  turnRate            = 320,
  upright             = true,
  waterline           = 15,
  workerTime          = 0,

  weapons             = {

    {
      def                = [[STANDOFF_TORPEDO]],
      badTargetCategory  = [[FIXEDWING]],
      mainDir            = [[0 0 1]],
      maxAngleDif        = 90,
      onlyTargetCategory = [[SWIM FIXEDWING LAND SUB SINK FLOAT SHIP GUNSHIP]],
    },

  },


  weaponDefs          = {

    STANDOFF_TORPEDO = {
      name                    = [[Long Range Torpedo]],
      areaOfEffect            = 16,
      avoidFriendly           = false,
      burnblow                = true,
	  cegTag                  = [[torpedo_trail_big]],
      collideFriendly         = false,
      craterBoost             = 0,
      craterMult              = 0,

      damage                  = {
        default = 1200,
        subs    = 1200,
      },

      explosionGenerator      = [[custom:TORPEDO_HIT]],
	  flightTime			  = 8,
	  fireSubmersed			  = true,
	  fixedLauncher			  = true,
      impactOnly              = true,
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      interceptedByShieldType = 1,
      lineOfSight             = true,
      model                   = [[wep_t_barracuda.s3o]],
      noSelfDamage            = true,
      propeller               = [[1]],
      range                   = 1050,
      reloadtime              = 6,
      renderType              = 1,
      selfprop                = true,
      soundHit                = [[explosion/ex_underwater]],
      soundHitVolume		  = 12,
	  soundStart              = [[weapon/torpedo]],
	  soundStartVolume		  = 7,
      startVelocity           = 150,
      tolerance               = 32767,
      tracks                  = true,
      turnRate                = 5800,
      turret                  = false,
      waterWeapon             = true,
      weaponAcceleration      = 25,
      weaponType              = [[MissileLauncher]],
      weaponVelocity          = 250,
    },

  },


  featureDefs         = {

    DEAD  = {
      description      = [[Wreckage - Serpent]],
      blocking         = false,
      category         = [[corpses]],
      damage           = 2600,
      energy           = 0,
      featureDead      = [[DEAD2]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 6,
      footprintZ       = 6,
      height           = [[10]],
      hitdensity       = [[100]],
      metal            = 800,
      object           = [[serpent_dead]],
      reclaimable      = true,
      reclaimTime      = 800,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },


    DEAD2 = {
      description      = [[Debris - Serpent]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 2600,
      energy           = 0,
      featureDead      = [[HEAP]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 6,
      footprintZ       = 6,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 800,
      object           = [[debris3x3c.s3o]],
      reclaimable      = true,
      reclaimTime      = 800,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },


    HEAP  = {
      description      = [[Debris - Serpent]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 2600,
      energy           = 0,
      featurereclamate = [[SMUDGE01]],
      footprintX       = 6,
      footprintZ       = 6,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 400,
      object           = [[debris3x3c.s3o]],
      reclaimable      = true,
      reclaimTime      = 400,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

  },

}

return lowerkeys({ serpent = unitDef })
