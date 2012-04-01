unitDef = {
  unitname                      = [[factoryjump]],
  name                          = [[Jumpjet/Specialist Plant]],
  description                   = [[Produces Jumpjets and Special Walkers, Builds at 6 m/s]],
  acceleration                  = 0,
  bmcode                        = [[0]],
  brakeRate                     = 0,
  buildCostEnergy               = 550,
  buildCostMetal                = 550,
  builder                       = true,
  buildingGroundDecalDecaySpeed = 30,
  buildingGroundDecalSizeX      = 8,
  buildingGroundDecalSizeY      = 7,
  buildingGroundDecalType       = [[factoryjump_aoplane.dds]],

  buildoptions                  = {
    [[corfast]],
    [[puppy]],
    [[corpyro]],
	[[slowmort]],
    [[corcan]],
    [[corsumo]],
	[[firewalker]],
    [[armaak]],
	[[corsktl]],
  },

  buildPic                      = [[factoryjump.png]],
  buildTime                     = 550,
  canMove                       = true,
  canPatrol                     = true,
  canstop                       = [[1]],
  category                      = [[SINK UNARMED]],
  collisionVolumeOffsets        = [[0 0 0]],
  collisionVolumeScales         = [[112 112 112]],
  collisionVolumeTest           = 1,
  collisionVolumeType           = [[ellipsoid]],
  corpse                        = [[DEAD]],

  customParams                  = {
    description_de = [[Produziert Spezial- und Sprungd�senroboter]],
    helptext_de    = [[Hier werden au�ergew�hnliche Einheiten erzeugt, die durch spezielle F�higkeiten Distanzen schnell �berbr�cken k�nnen, um in den Nahkampf zu treten oder auch, um Hindernisse schnell zu �berbr�cken. Wichtigste Einheiten: Pyro, Moderator, Jack, Firewalker, Sumo]],
    canjump  = [[1]],
    helptext = [[The esoteric Jumpjet/Specialist Plant offers unique tactical options for rapidly closing the distance in a knife fight, or getting over hills and rivers to cut a path through enemy lines. Key units: Pyro, Moderator, Jack, Firewalker, Sumo]],
    sortName = [[5]],
  },

  energyMake                    = 0.3,
  energyUse                     = 0,
  explodeAs                     = [[LARGE_BUILDINGEX]],
  footprintX                    = 7,
  footprintZ                    = 7,
  iconType                      = [[facjumpjet]],
  idleAutoHeal                  = 5,
  idleTime                      = 1800,
  mass                          = 324,
  maxDamage                     = 4000,
  maxSlope                      = 15,
  maxVelocity                   = 0,
  maxWaterDepth                 = 0,
  metalMake                     = 0.3,
  minCloakDistance              = 150,
  noAutoFire                    = false,
  objectName                    = [[factoryjump.s3o]],
  script						= [[factoryjump.lua]],
  seismicSignature              = 4,
  selfDestructAs                = [[LARGE_BUILDINGEX]],
  showNanoSpray                 = false,
  side                          = [[CORE]],
  sightDistance                 = 273,
  smoothAnim                    = true,
  TEDClass                      = [[PLANT]],
  turnRate                      = 0,
  useBuildingGroundDecal        = true,
  workerTime                    = 5,
  yardMap                       = [[ooooooo ooooooo occccco ycccccy ycccccy ycccccy ycccccy]],

  featureDefs                   = {

    DEAD  = {
      description      = [[Wreckage - Jumpjet Factory]],
      blocking         = true,
      category         = [[corpses]],
      damage           = 4000,
      energy           = 0,
      featureDead      = [[HEAP]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 5,
      footprintZ       = 6,
      height           = [[20]],
      hitdensity       = [[100]],
      metal            = 220,
      object           = [[factoryjump_dead.s3o]],
      reclaimable      = true,
      reclaimTime      = 220,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },


    HEAP  = {
      description      = [[Debris - Jumpjet Factory]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 4000,
      energy           = 0,
      featurereclamate = [[SMUDGE01]],
      footprintX       = 5,
      footprintZ       = 5,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 110,
      object           = [[debris4x4c.s3o]],
      reclaimable      = true,
      reclaimTime      = 110,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

  },

}

return lowerkeys({ factoryjump = unitDef })
