//
//Based on "https://github.com/assimp/assimp/blob/master/include/assimp/cimport.h" (7.8.2024)
//
package assimp

import "core:c"

#assert(size_of(c.int) >= size_of(i32))

Origin :: enum c.int {
	SET = 0,
	CUR = 1,
	END = 2,
}

MetadataType :: enum c.int {
	BOOL     = 0,
	INT32    = 1,
	UINT64   = 2,
	FLOAT    = 3,
	DOUBLE   = 4,
	STRING   = 5,
	VECTOR3D = 6,
	METADATA = 7,
	INT64    = 8,
	UINT32   = 9,
	META_MAX = 10,
}

PrimitiveTypeFlags :: distinct bit_set[PrimitiveTypeFlag;c.uint]
PrimitiveTypeFlag :: enum {
	POINT            = 0,
	LINE             = 1,
	TRIANGLE         = 2,
	POLYGON          = 3,
	NGONEncodingFlag = 4,
}

MorphingMethod :: enum (c.int when ASSIMP_API_VERSION >= "5.3.0" else c.uint) {
	UNKNOWN          = 0,
	VERTEX_BLEND     = 1,
	MORPH_NORMALIZED = 2,
	MORPH_RELATIVE   = 3,
}

TextureOp :: enum c.int {
	Multiply  = 0,
	Add       = 1,
	Subtract  = 2,
	Divide    = 3,
	SmoothAdd = 4,
	SignedAdd = 5,
}

TextureMapMode :: enum c.int {
	Wrap   = 0,
	Clamp  = 1,
	Decal  = 3,
	Mirror = 2,
}

TextureMapping :: enum c.int {
	UV       = 0,
	SPHERE   = 1,
	CYLINDER = 2,
	BOX      = 3,
	PLANE    = 4,
	OTHER    = 5,
}

TextureType :: enum c.int {
	NONE              = 0,
	DIFFUSE           = 1,
	SPECULAR          = 2,
	AMBIENT           = 3,
	EMISSIVE          = 4,
	HEIGHT            = 5,
	NORMALS           = 6,
	SHININESS         = 7,
	OPACITY           = 8,
	DISPLACEMENT      = 9,
	LIGHTMAP          = 10,
	REFLECTION        = 11,
	BASE_COLOR        = 12,
	NORMAL_CAMERA     = 13,
	EMISSION_COLOR    = 14,
	METALNESS         = 15,
	DIFFUSE_ROUGHNESS = 16,
	AMBIENT_OCCLUSION = 17,
	SHEEN             = 19,
	CLEARCOAT         = 20,
	TRANSMISSION      = 21,
	UNKNOWN           = 18,
}
TEXTURE_TYPE_MAX :: TextureType.TRANSMISSION

ShadingMode :: enum c.int {
	Flat         = 1,
	Gouraud      = 2,
	Phong        = 3,
	Blinn        = 4,
	Toon         = 5,
	OrenNayar    = 6,
	Minnaert     = 7,
	CookTorrance = 8,
	NoShading    = 9,
	Unlit        = NoShading,
	Fresnel      = 10,
	PBR_BRDF     = 11,
}

TextureFlags :: distinct bit_set[TextureFlag;c.uint]
TextureFlag :: enum {
	Invert      = 0,
	UseAlpha    = 1,
	IgnoreAlpha = 2,
}

BlendMode :: enum c.int {
	Default  = 0,
	Additive = 1,
}

PropertyTypeInfo :: enum c.int {
	Float   = 1,
	Double  = 2,
	String  = 3,
	Integer = 4,
	Buffer  = 5,
}

AnimInterpolation :: enum c.int {
	Step             = 0,
	Linear           = 1,
	Spherical_Linear = 2,
	Cubic_Spline     = 3,
}

AnimBehavior :: enum c.int {
	DEFAULT  = 0,
	CONSTANT = 1,
	LINEAR   = 2,
	REPEAT   = 3,
}

LightSourceType :: enum c.int {
	UNDEFINED   = 0,
	DIRECTIONAL = 1,
	POINT       = 2,
	SPOT        = 3,
	AMBIENT     = 4,
	AREA        = 5,
}

SceneFlags :: distinct bit_set[SceneFlag;c.uint]
SceneFlag :: enum {
	INCOMPLETE         = 0,
	VALIDATED          = 1,
	VALIDATION_WARNING = 2,
	NON_VERBOSE_FORMAT = 3,
	TERRAIN            = 4,
	ALLOW_SHARED       = 5,
}

// TODO: Maybe use bitsets instead
DefaultLogStream :: enum c.int {
	FILE     = 1 << 0,
	STDOUT   = 1 << 1,
	STDERR   = 1 << 2,
	DEBUGGER = 1 << 3, //MSVC: only (relies on WIN32 SDK)
}

Return :: enum c.int {
	SUCCESS     = 0,
	FAILURE     = -1,
	OUTOFMEMORY = -3,
}

ImporterFlags :: distinct bit_set[ImporterFlag;c.int]
ImporterFlag :: enum {
	SupportTextFlavour       = 0,
	SupportBinaryFlavour     = 1,
	SupportCompressedFlavour = 2,
	LimitedSupport           = 3,
	Experimental             = 4,
}

PostProcessStepsFlags :: distinct bit_set[PostProcessStepsFlag;c.uint]
PostProcessStepsFlag :: enum {
	CalcTangentSpace         = 0,
	JoinIdenticalVertices    = 1,
	MakeLeftHanded           = 2,
	Triangulate              = 3,
	RemoveComponent          = 4,
	GenNormals               = 5,
	GenSmoothNormals         = 6,
	SplitLaregMeshes         = 7,
	PreTransformVertices     = 8,
	LimitBoneWieghts         = 9,
	ValidateDataStructure    = 10,
	ImproveCacheLocality     = 11,
	RemoveRedundantMaterials = 12,
	FixInfacingNormals       = 13,
	PopulateArmatureData     = 14,
	SortByPType              = 15,
	FindDegenerates          = 16,
	FindInvalidData          = 17,
	GenUVCoords              = 18,
	TransformUVCoords        = 19,
	FindInstances            = 20,
	OptimizeMeshes           = 21,
	OptimizeGraph            = 22,
	FlipUVs                  = 23,
	FlipWindingOrder         = 24,
	SplitByBoneCount         = 25,
	Debone                   = 26,
	GlobalScale              = 27,
	EmbedTextures            = 28,
	ForceGenNormals          = 29,
	DropNormals              = 30,
	GenBoundingBoxes         = 31,
}

ConvertToLeftHanded :: PostProcessStepsFlags{.MakeLeftHanded, .FlipUVs, .FlipWindingOrder}
TargetRealtime_Fast :: PostProcessStepsFlags {
	.CalcTangentSpace,
	.GenNormals,
	.JoinIdenticalVertices,
	.Triangulate,
	.GenUVCoords,
	.SortByPType,
}

TargetRealtime_Quality ::
	TargetRealtime_Fast -
	{.GenNormals} +
	{
			.GenSmoothNormals,
			.ImproveCacheLocality,
			.LimitBoneWieghts,
			.RemoveRedundantMaterials,
			.SplitLaregMeshes,
			.FindDegenerates,
			.FindInvalidData,
		}


TargetRealtime_MaxQuality ::
	TargetRealtime_Quality + {.FindInstances, .ValidateDataStructure, .OptimizeMeshes}
