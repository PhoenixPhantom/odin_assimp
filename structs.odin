//
//Based on "https://github.com/assimp/assimp/blob/master/include/assimp/cimport.h" (7.8.2024)
//
package assimp

import "core:c"

#assert(size_of(c.int) == size_of(b32))

Quaternion :: struct {
	w, x, y, z: real,
}

Matrix4x4 :: distinct [4][4]real //the first index is equivalent to the letters (a, b, c, d) in assimp, the second to the numbers (1, 2, 3, 4)
Matrix3x3 :: distinct [3][3]real

Vector3D :: distinct [3]real //access using v.x, v.y and v.z is given by odin
Vector2D :: distinct [2]real //see Vector3D
Color4D :: distinct [4]c.float //access using c.r, c.g, c.b, and c.a is given by the odin language
Color3D :: distinct [3]c.float


LogStream :: struct {
	callback: LogStreamCallback,
	user:     rawptr,
}

PropertyStore :: struct {
	sentinel: c.char,
}

MemoryInfo :: struct {
	textures:   c.uint,
	materials:  c.uint,
	meshes:     c.uint,
	nodes:      c.uint,
	animations: c.uint,
	cameras:    c.uint,
	lights:     c.uint,
	total:      c.uint,
}

String :: struct {
	length: c.uint32_t,
	data:   [MAXLEN]c.char,
}

AxisAlignedBoundingBox :: struct {
	mMin: Vector3D,
	mMax: Vector3D,
}

AABB :: AxisAlignedBoundingBox

ImporterDesc :: struct {
	mName:           cstring,
	mAuthor:         cstring,
	mMaintainer:     cstring,
	mComments:       cstring,
	mFlags:          c.uint,
	mMinMajor:       c.uint,
	mMinMinor:       c.uint,
	mMaxMajor:       c.uint,
	mMaxMinor:       c.uint,
	mFileExtensions: cstring, //list of file extensions this importer can handle
}

MetadataEntry :: struct {
	mType: MetadataType,
	mData: rawptr,
}

Metadata :: struct {
	mNumProperties: c.uint,
	mKeys:          [^]String, //may not be nil
	mValues:        [^]MetadataEntry, //may not be nil
}

Node :: struct {
	mName:           String,
	mTransformation: Matrix4x4,
	mParent:         ^Node,
	mNumChildren:    c.uint,
	mChildren:       [^]^Node,
	mNumMeshes:      c.uint,
	mMeshes:         [^]c.uint, //indices to the meshlist in the corresponding scene
	mMetaData:       ^Metadata,
}

Face :: struct {
	mNumIndices: c.uint,
	mIndices:    [^]c.uint,
}

VertexWeight :: struct {
	mVertexId: c.uint,
	mWeight:   real,
}

Bone :: struct {
	mName:         String,
	mNumWeights:   c.uint,
	mArmature:     ^Node,
	mNode:         ^Node,
	mWeights:      [^]VertexWeight,
	mOffsetMatrix: Matrix4x4,
}

AnimMesh :: struct {
	mName:          String,
	mVertices:      [^]Vector3D,
	mNormals:       [^]Vector3D,
	mTangents:      [^]Vector3D,
	mBitangents:    [^]Vector3D,
	mColors:        [MAX_NUMBER_OF_COLOR_SETS][^]Color4D,
	mTextureCoords: [MAX_NUMBER_OF_TEXTURECOORDS][^]Vector3D,
	mNumVertices:   c.uint,
	mWeight:        c.float,
}

Mesh :: AssimpMesh
when ASSIMP_API_VERSION >= "5.1.0" {
	@(private = "file")
	AssimpMesh :: struct {
		mPrimitiveTypes:     PrimitiveTypeFlags,
		mNumVertices:        c.uint,
		mNumFaces:           c.uint,
		mVertices:           [^]Vector3D, //nil if not present, otherwise: len == mNumVertices
		mNormals:            [^]Vector3D, //nil if not present, otherwise: len == mNumVertices
		mTangents:           [^]Vector3D, //nil if not present, otherwise: len == mNumVertices
		mBitangents:         [^]Vector3D, //nil if not present, otherwise: len == mNumVertices
		mColors:             [MAX_NUMBER_OF_COLOR_SETS][^]Color4D, //nil if not present, otherwise: len == mNumVertices
		mTextureCoords:      [MAX_NUMBER_OF_TEXTURECOORDS][^]Vector3D, //nil if not present, otherwise: len == mNumVertices
		mNumUVComponents:    [MAX_NUMBER_OF_TEXTURECOORDS]c.uint,
		mFaces:              [^]Face, //nil if not present, otherwise: len == mNumFaces
		mNumBones:           c.uint,
		mBones:              [^]^Bone, //nil if not present
		mMaterialIndex:      c.uint,
		mName:               String,
		mNumAnimMeshes:      c.uint,
		mAnimMeshes:         [^]^AnimMesh,
		mMethod:             MorphingMethod,
		mAABB:               AxisAlignedBoundingBox,
		mTextureCoordsNames: ^[^]String, // FIXIT: Find out how this thing is supposed to be accessed (the comment in the .h file is inherintly incoherent with the code and the official documentation is incoherent with both the code and the comment)

		// Vertex UV stream names. (seemingly) nil if not present (and can seemingly also point to nil, even if non-nill itself), Documentation states: "Pointer to array of size MAX_NUMBER_OF_TEXTURECOORDS"
	}
} else {
	@(private = "file")
	AssimpMesh :: struct {
		mPrimitiveTypes:     PrimitiveTypeFlags,
		mNumVertices:        c.uint,
		mNumFaces:           c.uint,
		mVertices:           [^]Vector3D, //nil if not present, otherwise: len == mNumVertices
		mNormals:            [^]Vector3D, //nil if not present, otherwise: len == mNumVertices
		mTangents:           [^]Vector3D, //nil if not present, otherwise: len == mNumVertices
		mBitangents:         [^]Vector3D, //nil if not present, otherwise: len == mNumVertices
		mColors:             [MAX_NUMBER_OF_COLOR_SETS][^]Color4D, //nil if not present, otherwise: len == mNumVertices
		mTextureCoords:      [MAX_NUMBER_OF_TEXTURECOORDS][^]Vector3D, //nil if not present, otherwise: len == mNumVertices
		mTextureCoordsNames: [MAX_NUMBER_OF_TEXTURECOORDS]String,
		mNumUVComponents:    [MAX_NUMBER_OF_TEXTURECOORDS]c.uint,
		mFaces:              [^]Face, //nil if not present, otherwise: len == mNumFaces
		mNumBones:           c.uint,
		mBones:              [^]^Bone, //nil if not present
		mMaterialIndex:      c.uint,
		mName:               String,
		mNumAnimMeshes:      c.uint,
		mAnimMeshes:         [^]^AnimMesh,
		mMethod:             MorphingMethod,
		mAABB:               AxisAlignedBoundingBox,
	}
}

SkeletonBone :: struct {
	mParent:       c.int, //The parent bone index (-1 if this is the root)
	mArmature:     ^Node,
	mNode:         ^Node,
	mNumWeights:   c.uint,
	mMeshId:       ^Mesh,
	mWeights:      [^]VertexWeight,
	mOffsetMatrix: Matrix4x4,
	mLocalMatrix:  Matrix4x4,
}

Skeleton :: struct {
	mName:     String,
	mNumBones: c.uint,
	mBones:    [^]^SkeletonBone,
}

UVTransform :: struct {
	mTranslation: Vector2D,
	mScaling:     Vector2D,
	mRotation:    real,
}

MaterialProperty :: struct {
	mKey:        String,
	mSemantic:   c.uint,
	mIndex:      c.uint,
	mDataLength: c.uint,
	mType:       PropertyTypeInfo,
	mData:       rawptr,
}

Material :: struct {
	mProperties:    [^]^MaterialProperty,
	mNumProperties: c.uint,
	mNumAllocated:  c.uint,
}

VectorKey :: struct {
	mTime:          c.double,
	mValue:         Vector3D,
	mInterpolation: AnimInterpolation,
}

QuatKey :: struct {
	mTime:          c.double,
	mValue:         Quaternion,
	mInterpolation: AnimInterpolation,
}

MeshKey :: struct {
	mTime:          c.double,
	mInterpolation: AnimInterpolation,
}

MeshMorphKey :: struct {
	mTime:                c.double,
	mValues:              [^]c.uint,
	mWeights:             [^]c.double,
	mNumValuesAndWeights: c.uint,
}

NodeAnim :: struct {
	mNodeName:        String,
	mNumPositionKeys: c.uint,
	mPositionKeys:    [^]VectorKey,
	mNumRotationKeys: c.uint,
	mRotationKeys:    [^]QuatKey,
	mNumScalingKeys:  c.uint,
	mScalingKeys:     [^]VectorKey,
	mPreState:        AnimBehavior,
	mPostState:       AnimBehavior,
}

MeshAnim :: struct {
	mName:    String,
	mNumKeys: c.uint,
	mKeys:    [^]NodeAnim,
}

MeshMorphAnim :: struct {
	mName:    String,
	mNumKeys: c.uint,
	mKeys:    [^]MeshMorphKey,
}

Animation :: struct {
	mName:                 String,
	mDuration:             c.double,
	mTicksPerSecond:       c.double,
	mNumChannels:          c.uint,
	mChannels:             [^]^NodeAnim,
	mNumMeshChannels:      c.uint,
	mMeshChannels:         [^]^MeshAnim,
	mNumMorphMeshChannels: c.uint,
	mMorphMeshChannels:    [^]^MeshMorphAnim,
}

Taxel :: struct {
	b, g, r, a: c.uchar,
}

Texture :: struct {
	mWidth:        c.uint,
	mHeight:       c.uint,
	achFormatHint: [HINTMAXTEXTURELEN]c.char,
	pcData:        ^Taxel,
	mFilename:     String,
}

Light :: struct {
	mName:                 String,
	mType:                 LightSourceType,
	mPosition:             Vector3D,
	mDirection:            Vector3D,
	mUp:                   Vector3D,
	mAttenuationConstant:  c.float,
	mAttenuationLinear:    c.float,
	mAttenuationQuadratic: c.float,
	mColorDiffuse:         Color3D,
	mColorSpecular:        Color3D,
	mColorAmbient:         Color3D,
	mAngleInnerCone:       c.float,
	mAngleOuterCone:       c.float,
	mSize:                 Vector2D,
}

Camera :: struct {
	mName:             String,
	mPosition:         Vector3D,
	mUp:               Vector3D,
	mLookAt:           Vector3D,
	mHorizontalFOV:    c.float,
	mClipPlaneNear:    c.float,
	mClipPlaneFar:     c.float,
	mAspect:           c.float,
	mOrtographicWidth: c.float,
}

Scene :: AssimpScene //this is to help the lsp's go to definition not get confused
when ASSIMP_API_VERSION >= "5.2.5" {
	@(private = "file")
	AssimpScene :: struct {
		mFlags:         SceneFlags,
		mRootNode:      ^Node,
		mNumMeshes:     c.uint,
		mMeshes:        [^]^Mesh,
		mNumMaterials:  c.uint,
		mMaterials:     [^]^Material,
		mNumAnimations: c.uint,
		mAnimations:    [^]^Animation,
		mNumTextures:   c.uint,
		mTextures:      [^]^Texture,
		mNumLights:     c.uint,
		mLights:        [^]^Light,
		mNumCameras:    c.uint,
		mCameras:       [^]^Camera,
		mMetaData:      ^Metadata,
		mName:          String,
		mNumSkeletons:  c.uint,
		mSkeletons:     [^]^Skeleton,
		mPrivate:       rawptr, //Internal data, do not touch
	}
} else {
	@(private = "file")
	AssimpScene :: struct {
		mFlags:         SceneFlags,
		mRootNode:      ^Node,
		mNumMeshes:     c.uint,
		mMeshes:        [^]^Mesh,
		mNumMaterials:  c.uint,
		mMaterials:     [^]^Material,
		mNumAnimations: c.uint,
		mAnimations:    [^]^Animation,
		mNumTextures:   c.uint,
		mTextures:      [^]^Texture,
		mNumLights:     c.uint,
		mLights:        [^]^Light,
		mNumCameras:    c.uint,
		mCameras:       [^]^Camera,
		mMetaData:      ^Metadata,
		mName:          String,
		//mNumSkeletons
		//mSkeletons
		mPrivate:       rawptr, //Internal data, do not touch
	}
}

FileIO :: struct {
	Open:     FileOpenProc,
	Close:    FileCloseProc,
	UserData: rawptr,
}

File :: struct {
	Read:      FileReadProc,
	FileWrite: FileWriteProc,
	FileTell:  FileTellProc,
	FileSize:  FileTellProc,
	Seek:      FileSeek,
	Flush:     FileFlushProc,
	UserData:  rawptr,
}

ExportFormatDesc :: struct {
	id:            cstring,
	description:   cstring,
	fileExtension: cstring,
}

ExportDataBlob :: struct {
	size: c.size_t,
	data: rawptr,
	name: String,
	next: ^ExportDataBlob,
}
