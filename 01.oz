{Show '1-6-a'}
declare
fun {ShiftLeft L}
   case L of H|T then
      H|{ShiftLeft T}
   else
      [0]
   end
end

fun {ShiftRight L}
   0|L
end

fun {OpList Op L1 L2}
   case L1 of H1|T1 then
      case L2 of H2|T2 then
	 {Op H1 H2}|{OpList Op T1 T2}
      end
   else
      nil
   end
end

fun {GenericPascal Op N}
   if N == 1 then [1]
   else L in
      L = {GenericPascal Op N-1}
      {OpList Op {ShiftLeft L} {ShiftRight L}}
   end
end

fun {Add X Y}
   X + Y
end

fun {Minus X Y}
   X - Y
end

fun {Mul X Y}
   X * Y
end

fun {Mull X Y}
   (X + 1) * (Y + 1)
end

{Show {GenericPascal Add 5}}
{Show {GenericPascal Minus 5}}
{Show {GenericPascal Mul 5}}
{Show {GenericPascal Mull 10}}

{Show '1-6-b'}
for Op in [Add Minus Mul Mull] do
   for I in 1..10 do
      {Show {GenericPascal Op I}}
   end
end

{Show '1-7'}
local X in
   X = 23
   local X in
      X = 44
   end
   {Show X}
end

local X in
   X = {NewCell 23}
   X := 44
   {Show @X}
end

{Show '1-8'}
declare
fun {AccumulateFun}
   Acc = {NewCell 0}
   fun {Impl N}
      Acc := @Acc + N
      @Acc
   end in
   Impl
end
Accumulate = {AccumulateFun}

{Show {Accumulate 5}}
{Show {Accumulate 100}}
{Show {Accumulate 45}}

{Show '1-9-a'}
% Load file.
% The memory store as used in the exercises
declare
fun {NewStore}
   D={NewDictionary}
   C={NewCell 0}
   proc {Put K X}
      if {Not {Dictionary.member D K}} then
         C:=@C+1
      end
      D.K:=X
   end
   fun {Get K} D.K end
   fun {Size} @C end
in
   storeobject(put:Put get:Get size:Size)
end
proc {Put S K X} {S.put K X} end
fun {Get S K} {S.get K} end
fun {Size S} {S.size} end

S = {NewStore}
{Put S 2 [22 33]}
{Show {Get S 2}}
{Show {Size S}}

{Show '1-9-b'}
fun {FastPascal N S}
   if N == 1 then
      [1]
   else L in
      L = {FastPascal N-1 S}
      {Put S N L}
      {OpList Add {ShiftLeft L} {ShiftRight L}}
   end
end

fun {FasterPascalFun}
   S = {NewStore}
   fun {Impl N}
      if {Size S} >= N - 1 then
	 {Get S N}
      else
	 {FastPascal N S}
      end
   end in
   Impl
end

FasterPascal = {FasterPascalFun}
{Show {FasterPascal 5}}
{Show {FasterPascal 4}}

{Show '1-9-c'}
declare
fun {NNewStore}
   {NewCell nil}
end

fun {NSize C} 
   fun {Counter L N}
      case L of H|T then
	 {Counter T N+1}
      else
	 N
      end
   end in
   {Counter @C 0}
end

fun {NFind C N}
   fun {Find L N}
      case L of H|T then
	 if @H.1 == N then
	    H
	 else
	    {Find T N}
	 end
      else
	 nil
      end
   end in
   {Find @C N}
end

fun {NGet C N}
   Stored = {NFind C N} in
   if Stored == nil then
      nil
   else
      @Stored.2
   end
end
   

fun {NPut C N V}
   Stored = {NFind C N} in
   if Stored == nil then
      C := {NewCell N|V}|@C
   else
     Stored := N|V
   end
end

C = {NNewStore}
{Show {NSize C}}
{Show {NGet C 1}}
{NPut C 1 100 _}
{NPut C 2 200 _}
{Show {NGet C 1}}
{Show {NGet C 2}}
{Show {NSize C}}