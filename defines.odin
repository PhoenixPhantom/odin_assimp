//
//Based on "https://github.com/assimp/assimp/blob/master/include/assimp/cimport.h" (7.8.2024)
//
package assimp

import "core:c"

//the API version can be provided to this library using odin's defines as different versions are minorly incompatible with oneanother
//e.g. on debian based systems, the version optained through apt get libassimp-dev is (as of 7.8.2024) 5.2.2 as opposed to the newest 5.4.2
ASSIMP_API_VERSION :: #config(ASIMP_API_VERSION, "5.2.2")

ASIMP_DOUBLE_PERCISION :: #config(ASIMP_DOUBLE_PERCISION, false)
real :: distinct (c.double when ASIMP_DOUBLE_PERCISION else c.float)


MAXLEN :: 1024
// NOTE: the following definitions can be adjusted to account for custom non-default builds of assimp (where these defines were changed as well)
MAX_FACES_INDICES :: #config(ASSIMP_MAX_FACES_INDICES, 0x7fff)
MAX_BONE_WEIGHTS :: #config(ASSIMP_MAX_BONE_WEIGHTS, 0x7fffffff)
MAX_VERTICES :: #config(ASSIMP_MAX_VERTICES, 0x7fffffff)
MAX_FACES :: #config(ASSIMP_MAX_FACES, 0x7fffffff)
MAX_NUMBER_OF_COLOR_SETS :: #config(ASSIMP_MAX_NUMBER_OF_COLOR_SEATS, 0x8)
MAX_NUMBER_OF_TEXTURECOORDS :: #config(ASSIMP_MAX_NUMBER_OF_TEXTURECOORDS, 0x8)

// Name for default materials (2nd is used if meshes have UV coords)
DEFAULT_MATERIAL_NAME :: "DefaultMaterial"

HINTMAXTEXTURELEN :: 9

/*
// ---------------------------------------------------------------------------
#define AI_MATKEY_NAME "?mat.name", 0, 0
#define AI_MATKEY_TWOSIDED "$mat.twosided", 0, 0
#define AI_MATKEY_SHADING_MODEL "$mat.shadingm", 0, 0
#define AI_MATKEY_ENABLE_WIREFRAME "$mat.wireframe", 0, 0
#define AI_MATKEY_BLEND_FUNC "$mat.blend", 0, 0
#define AI_MATKEY_OPACITY "$mat.opacity", 0, 0
#define AI_MATKEY_TRANSPARENCYFACTOR "$mat.transparencyfactor", 0, 0
#define AI_MATKEY_BUMPSCALING "$mat.bumpscaling", 0, 0
#define AI_MATKEY_SHININESS "$mat.shininess", 0, 0
#define AI_MATKEY_REFLECTIVITY "$mat.reflectivity", 0, 0
#define AI_MATKEY_SHININESS_STRENGTH "$mat.shinpercent", 0, 0
#define AI_MATKEY_REFRACTI "$mat.refracti", 0, 0
#define AI_MATKEY_COLOR_DIFFUSE "$clr.diffuse", 0, 0
#define AI_MATKEY_COLOR_AMBIENT "$clr.ambient", 0, 0
#define AI_MATKEY_COLOR_SPECULAR "$clr.specular", 0, 0
#define AI_MATKEY_COLOR_EMISSIVE "$clr.emissive", 0, 0
#define AI_MATKEY_COLOR_TRANSPARENT "$clr.transparent", 0, 0
#define AI_MATKEY_COLOR_REFLECTIVE "$clr.reflective", 0, 0
#define AI_MATKEY_GLOBAL_BACKGROUND_IMAGE "?bg.global", 0, 0
#define AI_MATKEY_GLOBAL_SHADERLANG "?sh.lang", 0, 0
#define AI_MATKEY_SHADER_VERTEX "?sh.vs", 0, 0
#define AI_MATKEY_SHADER_FRAGMENT "?sh.fs", 0, 0
#define AI_MATKEY_SHADER_GEO "?sh.gs", 0, 0
#define AI_MATKEY_SHADER_TESSELATION "?sh.ts", 0, 0
#define AI_MATKEY_SHADER_PRIMITIVE "?sh.ps", 0, 0
#define AI_MATKEY_SHADER_COMPUTE "?sh.cs", 0, 0

// ---------------------------------------------------------------------------
// PBR material support
// --------------------
// Properties defining PBR rendering techniques
#define AI_MATKEY_USE_COLOR_MAP "$mat.useColorMap", 0, 0

// Metallic/Roughness Workflow
// ---------------------------
// Base RGBA color factor. Will be multiplied by final base color texture values if extant
// Note: Importers may choose to copy this into AI_MATKEY_COLOR_DIFFUSE for compatibility
// with renderers and formats that do not support Metallic/Roughness PBR
#define AI_MATKEY_BASE_COLOR "$clr.base", 0, 0
#define AI_MATKEY_BASE_COLOR_TEXTURE aiTextureType_BASE_COLOR, 0
#define AI_MATKEY_USE_METALLIC_MAP "$mat.useMetallicMap", 0, 0
// Metallic factor. 0.0 = Full Dielectric, 1.0 = Full Metal
#define AI_MATKEY_METALLIC_FACTOR "$mat.metallicFactor", 0, 0
#define AI_MATKEY_METALLIC_TEXTURE aiTextureType_METALNESS, 0
#define AI_MATKEY_USE_ROUGHNESS_MAP "$mat.useRoughnessMap", 0, 0
// Roughness factor. 0.0 = Perfectly Smooth, 1.0 = Completely Rough
#define AI_MATKEY_ROUGHNESS_FACTOR "$mat.roughnessFactor", 0, 0
#define AI_MATKEY_ROUGHNESS_TEXTURE aiTextureType_DIFFUSE_ROUGHNESS, 0
// Anisotropy factor. 0.0 = isotropic, 1.0 = anisotropy along tangent direction,
// -1.0 = anisotropy along bitangent direction
#define AI_MATKEY_ANISOTROPY_FACTOR "$mat.anisotropyFactor", 0, 0

// Specular/Glossiness Workflow
// ---------------------------
// Diffuse/Albedo Color. Note: Pure Metals have a diffuse of {0,0,0}
// AI_MATKEY_COLOR_DIFFUSE
// Specular Color.
// Note: Metallic/Roughness may also have a Specular Color
// AI_MATKEY_COLOR_SPECULAR
#define AI_MATKEY_SPECULAR_FACTOR "$mat.specularFactor", 0, 0
// Glossiness factor. 0.0 = Completely Rough, 1.0 = Perfectly Smooth
#define AI_MATKEY_GLOSSINESS_FACTOR "$mat.glossinessFactor", 0, 0

// Sheen
// -----
// Sheen base RGB color. Default {0,0,0}
#define AI_MATKEY_SHEEN_COLOR_FACTOR "$clr.sheen.factor", 0, 0
// Sheen Roughness Factor.
#define AI_MATKEY_SHEEN_ROUGHNESS_FACTOR "$mat.sheen.roughnessFactor", 0, 0
#define AI_MATKEY_SHEEN_COLOR_TEXTURE aiTextureType_SHEEN, 0
#define AI_MATKEY_SHEEN_ROUGHNESS_TEXTURE aiTextureType_SHEEN, 1

// Clearcoat
// ---------
// Clearcoat layer intensity. 0.0 = none (disabled)
#define AI_MATKEY_CLEARCOAT_FACTOR           "$mat.clearcoat.factor", 0, 0
#define AI_MATKEY_CLEARCOAT_ROUGHNESS_FACTOR "$mat.clearcoat.roughnessFactor", 0, 0
#define AI_MATKEY_CLEARCOAT_TEXTURE aiTextureType_CLEARCOAT, 0
#define AI_MATKEY_CLEARCOAT_ROUGHNESS_TEXTURE aiTextureType_CLEARCOAT, 1
#define AI_MATKEY_CLEARCOAT_NORMAL_TEXTURE aiTextureType_CLEARCOAT, 2

// Transmission
// ------------
// https://github.com/KhronosGroup/glTF/tree/master/extensions/2.0/Khronos/KHR_materials_transmission
// Base percentage of light transmitted through the surface. 0.0 = Opaque, 1.0 = Fully transparent
#define AI_MATKEY_TRANSMISSION_FACTOR "$mat.transmission.factor", 0, 0
// Texture defining percentage of light transmitted through the surface.
// Multiplied by AI_MATKEY_TRANSMISSION_FACTOR
#define AI_MATKEY_TRANSMISSION_TEXTURE aiTextureType_TRANSMISSION, 0

// Volume
// ------------
// https://github.com/KhronosGroup/glTF/tree/main/extensions/2.0/Khronos/KHR_materials_volume
// The thickness of the volume beneath the surface. If the value is 0 the material is thin-walled. Otherwise the material is a volume boundary.
#define AI_MATKEY_VOLUME_THICKNESS_FACTOR "$mat.volume.thicknessFactor", 0, 0
// Texture that defines the thickness.
// Multiplied by AI_MATKEY_THICKNESS_FACTOR
#define AI_MATKEY_VOLUME_THICKNESS_TEXTURE aiTextureType_TRANSMISSION, 1
// Density of the medium given as the average distance that light travels in the medium before interacting with a particle.
#define AI_MATKEY_VOLUME_ATTENUATION_DISTANCE "$mat.volume.attenuationDistance", 0, 0
// The color that white light turns into due to absorption when reaching the attenuation distance.
#define AI_MATKEY_VOLUME_ATTENUATION_COLOR "$mat.volume.attenuationColor", 0, 0

// Emissive
// --------
#define AI_MATKEY_USE_EMISSIVE_MAP   "$mat.useEmissiveMap", 0, 0
#define AI_MATKEY_EMISSIVE_INTENSITY "$mat.emissiveIntensity", 0, 0
#define AI_MATKEY_USE_AO_MAP         "$mat.useAOMap", 0, 0

// ---------------------------------------------------------------------------
// Pure key names for all texture-related properties
//! @cond MATS_DOC_FULL
#define _AI_MATKEY_TEXTURE_BASE       "$tex.file"
#define _AI_MATKEY_UVWSRC_BASE        "$tex.uvwsrc"
#define _AI_MATKEY_TEXOP_BASE         "$tex.op"
#define _AI_MATKEY_MAPPING_BASE       "$tex.mapping"
#define _AI_MATKEY_TEXBLEND_BASE      "$tex.blend"
#define _AI_MATKEY_MAPPINGMODE_U_BASE "$tex.mapmodeu"
#define _AI_MATKEY_MAPPINGMODE_V_BASE "$tex.mapmodev"
#define _AI_MATKEY_TEXMAP_AXIS_BASE   "$tex.mapaxis"
#define _AI_MATKEY_UVTRANSFORM_BASE   "$tex.uvtrafo"
#define _AI_MATKEY_TEXFLAGS_BASE      "$tex.flags"
//! @endcond
*/
