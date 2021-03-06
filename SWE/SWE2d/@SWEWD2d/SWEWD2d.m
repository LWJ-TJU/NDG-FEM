classdef SWEWD2d < SWEPreBlanaced2d
    
    methods( Access = protected )
        function [ fphys ] = matEvaluatePostFunc(obj, fphys)
            fphys = matEvaluatePostFunc@SWEAbstract2d( obj, fphys );
            obj.matUpdateWetDryState( fphys );
        end% func
        
        function fphys = matEvaluateLimiter( obj, fphys )
            obj.matUpdateWDWetDryState( fphys )
            for m = 1:obj.Nmesh
                mesh = obj.meshUnion(m);
                flg = (mesh.EToR == int8( NdgRegionType.PartialWet ) );
                
                tempWD = mesh.cell.V \ fphys{m}(:, flg, 1);
                ind = tempWD(1, :) < 0;
                tempWD(1, ind) = 0;
                tempWD(4:end, :) = 0;
                fphys{m}(:, flg, 1) = mesh.cell.V * tempWD;
                
                for fld = 2:obj.Nvar % reconstruct the WD cell values
                    tempWD = mesh.cell.V \ fphys{m}(:, flg, fld);
                    tempWD(4:end, :) = 0;
                    fphys{m}(:, flg, fld) = mesh.cell.V * tempWD;
                end
            end
            
            fphys = matEvaluateLimiter@SWEPreBlanaced2d( obj, fphys );
        end% func
        
        function matUpdateWDWetDryState(obj, fphys)
            for m = 1:obj.Nmesh
                
                mesh = obj.meshUnion(m);
                % wet part
                wetflg = all( fphys{m}(:,:,1) >= obj.hmin );
                mesh.EToR( wetflg ) = int8( NdgRegionType.Wet );
                % dry part
                dryflag = all( fphys{m}(:,:,1) < obj.hmin );
                mesh.EToR( dryflag ) = int8( NdgRegionType.Dry );
                % partial wet part
                flg = ( ~wetflg ) & ( ~dryflag );
                mesh.EToR( flg ) = int8( NdgRegionType.PartialWet );
                
            end
        end% func
    end
    
end

