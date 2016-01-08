%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                             %
% This file is part of openLilyLib,                                           %
%                      ===========                                            %
% the community library project for GNU LilyPond                              %
% (https://github.com/openlilylib)                                            %
%              -----------                                                    %
%                                                                             %
% Library: oll-core                                                           %
%          ========                                                           %
%                                                                             %
% openLilyLib is free software: you can redistribute it and/or modify         %
% it under the terms of the GNU General Public License as published by        %
% the Free Software Foundation, either version 3 of the License, or           %
% (at your option) any later version.                                         %
%                                                                             %
% openLilyLib is distributed in the hope that it will be useful,              %
% but WITHOUT ANY WARRANTY; without even the implied warranty of              %
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               %
% GNU General Public License for more details.                                %
%                                                                             %
% You should have received a copy of the GNU General Public License           %
% along with openLilyLib. If not, see <http://www.gnu.org/licenses/>.         %
%                                                                             %
% openLilyLib is maintained by Urs Liska, ul@openlilylib.org                  %
% and others.                                                                 %
%       Copyright Urs Liska, 2016                                             %
%                                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Provides scheme/music/void-functions dealing with "this" file.
% "this" represents the file in which the function is *called*

% processing "location" arguments

#(define-public (location->normalized-path location)
   "Returns a normalized path to the given location object"
   (os-path-normalize (car (ly:input-file-line-char-column location))))

#(define-public (location-extract-path location)
   "Returns the normalized path from a LilyPond location
    or './' if 'location' is in the same directory."
   (let* ((loc (location->normalized-path location))
          (dirmatch (string-match "(.*/).*" loc))
          (dirname (if (regexp-match? dirmatch)
                       (let ((full-string (match:substring dirmatch 1)))
                         (substring full-string
                           0
                           (- (string-length full-string) 1)))
                       ".")))
     (os-path-normalize dirname)))


%%%%%%%%%%%%%%%%%%
% "this" functions
%
% These functions operate on the file where they are used
% (i.e. *not* necessarily the file that is currently compiled)

% Return the normalized absolute path and file name of the
% file where this function is called from (not the one that
% is compiled by LilyPond).
#(define-public thisFile
   (define-scheme-function ()()
     (normalize-location (*location*))))

#(define-public thisDir
   (define-scheme-function ()()
     (dirname (thisFile))))

thisFileCompiled =
#(define-scheme-function ()()
   "Return #t if the file where this function is called
    is the one that is currently compiled by LilyPond."
   (let ((outname (ly:parser-output-name (*parser*)))
         (locname (normalize-location (*location*))))
     (regexp-match? (string-match (format "^(.*/)?~A\\.i?ly$" outname) locname))))
