unitDef = {
  unitname               = [[corsy]],
  name                   = [[Shipyard]],
  description            = [[Produces Ships, Builds at10 m/s]],
  acceleration           = 0,
  brakeRate              = 0,
  buildCostEnergy        = 700,
  buildCostMetal         = 700,
  builder                = true,

  buildoptions           = {
    [[corcs]],
    [[armpt]],
    [[coresupp]],
    [[dclship]],
    [[corsub]],
    [[armroy]],
    [[corroy]],
    [[serpent]],
    [[corarch]],
    [[armtboat]],
  },

  buildPic               = [[CORSY.png]],
  buildTime              = 700,
  canMove                = true,
  canPatrol              = true,
  canStop                = true,
  category               = [[UNARMED FLOAT]],
  collisionVolumeOffsets = [[0 0 0]],
  collisionVolumeScales  = [[134 80 214]],
  collisionVolumeTest    = 1,
  collisionVolumeType    = [[Box]],
  corpse                 = [[DEAD]],

  customParams           = {
    description_de = [[Produziert Schiffe, Baut mit 6 M/s]],
	helptext_de    = [[Im Shipyard kannst du Schiffe jeder Art und f�r jeden Zweck bauen.]],
    sortName = [[7]],
  },

  energyMake             = 0.3,
  energyUse              = 0,
  explodeAs              = [[LARGE_BUILDINGEX]],
  footprintX             = 9,
  footprintZ             = 14,
  iconType               = [[facship]],
  idleAutoHeal           = 5,
  idleTime               = 1800,
  mass                   = 324,
  maxDamage              = 6000,
  maxSlope               = 15,
  maxVelocity            = 0,
  metalMake              = 0.3,
  minCloakDistance       = 150,
  minWaterDepth          = 30,
  modelCenterOffset      = [[0 20 4]],
  objectName             = [[seafac.s3o]],
  script				 = [[corsy.lua]],
  seismicSignature       = 4,
  selfDestructAs         = [[LARGE_BUILDINGEX]],
  showNanoSpray          = false,
  side                   = [[CORE]],
  sightDistance          = 273,
  turnRate               = 0,
  waterline              = 0,
  workerTime             = 10,
  yardMap                = [[oocccccco oocccccco oocccccco oocccccco oocccccco oocccccco oocccccco oocccccco oocccccco oocccccco oocccccco oocccccco oocccccco oocccccco]],

  featureDefs            = {

    DEAD  = {
      description      = [[Wreckage - Shipyard]],
      blocking         = false,
      category         = [[corpses]],
      damage           = 6000,
      energy           = 0,
      featureDead      = [[HEAP]],
      footprintX       = 9,
      footprintZ       = 14,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 280,
      object           = [[seafac_dead.s3o]],
      reclaimable      = true,
      reclaimTime      = 280,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },



    HEAP  = {
      description      = [[Debris - Shipyard]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 6000,
      energy           = 0,
      featurereclamate = [[SMUDGE01]],
      footprintX       = 8,
      footprintZ       = 8,
      hitdensity       = [[100]],
      metal            = 140,
      object           = [[debris4x4c.s3o]],
      reclaimable      = true,
      reclaimTime      = 140,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

  },

}

return lowerkeys({ corsy = unitDef })
