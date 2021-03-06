#ifndef __mxSWE_H__
#define __mxSWE_H__

#include "mex.h"
#define max(a, b) ((a > b) ? a : b)
#define min(a, b) ((a < b) ? a : b)

#define EPS 1e-6

typedef enum {
  NdgRegionNormal = 1,
  NdgRegionRefine = 2,
  NdgRegionSponge = 3,
  NdgRegionWet = 4,
  NdgRegionDry = 5,
} NdgRegionType;

typedef enum {
  NdgEdgeInner = 0,
  NdgEdgeGaussEdge = 1,
  NdgEdgeSlipWall = 2,
  NdgEdgeNonSlipWall = 3,
  NdgEdgeZeroGrad = 4,
  NdgEdgeClamped = 5,
  NdgEdgeClampedDepth = 6,
  NdgEdgeClampedVel = 7,
  NdgEdgeFlather = 8
} NdgEdgeType;

typedef struct {
  size_t K;
  size_t Np;
  size_t Nfield;
  double* h;
  double* hu;
  double* hv;
  double* z;
} PhysField;

/** convert mex variable to PhysVolField structure */
inline PhysField convertMexToPhysField(const mxArray* mxfield) {
  const mwSize* dims = mxGetDimensions(mxfield);
  PhysField field;
  field.Np = dims[0];
  field.K = dims[1];
  field.Nfield = dims[2];
  const size_t Ntmp = field.Np * field.K;

  field.h = mxGetPr(mxfield);
  field.hu = field.h + Ntmp;
  field.hv = field.hu + Ntmp;
  field.z = field.hv + Ntmp;

  return field;
}

/** Evaluate the flow rate depending on the depth threshold */
void evaluateFlowRateByDeptheThreshold(const double hcrit, const double h,
                                       const double hu, const double hv,
                                       double* u, double* v);
/**
 Evaluate the flow rate depending on the cell states
 */
void evaluateFlowRateByCellState(const NdgRegionType type, const double h,
                                 const double hu, const double hv, double* u,
                                 double* v);

void evaluateSlipWallAdjacentNodeValue(const double nx, const double ny,
                                       double* fm, double* fp);

void evaluateNonSlipWallAdjacentNodeValue(const double nx, const double ny,
                                          double* fm, double* fp);

void evaluateFlatherAdjacentNodeValue(double nx, double ny, double* fm,
                                      double* fe);

#endif  //__mxSWE_H__